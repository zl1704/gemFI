//
// Created by zl on 2020/6/20.
//

#ifndef TT_COMPILE_INFO_H
#define TT_COMPILE_INFO_H

#include <vector>
#include <libdwarf.h>
#include <map>

#include "base/types.hh"
/**
 * Compilation Unit :
 *      Compilation Files
 */

class CompilationFile;

class Variable;

class Function;

class Type
{

public:
    virtual uint32_t size() = 0;
    virtual void print(bool nl = true){};
};

class BasicType : public Type
{
private:
    uint8_t _size;
    uint8_t _encoding;
    std::string _name;

public:
    BasicType(uint8_t size, uint8_t encoding, std::string name) : _size(size), _encoding(encoding), _name(name)
    {
    }
    virtual void print(bool nl = true);
    virtual uint32_t size() { return _size; }
};

class ConstType : public Type
{
private:
    Type *cTy;

public:
    ConstType(Type *Ty) : cTy(Ty) {}
    void setType(Type *Ty) { cTy = Ty; }
    virtual void print(bool nl = true);
    virtual uint32_t size() { return cTy->size(); };
};

class VoidType : public Type
{

public:
    VoidType() {}
    virtual void print(bool nl = true);
    virtual uint32_t size() { return 0; };
};

class PtrType : public Type
{
private:
    uint8_t _size;
    Type *baseType;

public:
    PtrType(uint8_t size, Type *bType) : _size(size), baseType(bType)
    {
    }
    void setType(Type *bTy) { baseType = bTy; }
    virtual void print(bool nl = true);
    virtual uint32_t size() { return _size; };
};

class ArrayType : public Type
{
private:
    Type *baseType;
    std::vector<uint32_t> subranges;
    uint32_t _size;

public:
    ArrayType(Type *bType, std::vector<uint32_t> subrgs);
    virtual void print(bool nl = true);
    virtual uint32_t size() { return _size; };
};

class StructType : public Type
{

private:
    std::vector<Variable *> _chs;

    uint32_t _size;

public:
    StructType() { _size = 0; };

    void addVar(Variable *v) { _chs.push_back(v); }

    virtual void print(bool nl = true);

    virtual uint32_t size();
};

class TypeDefType : public Type
{
private:
    Type *cTy;

public:
    TypeDefType(Type *Ty) : cTy(Ty)
    {
    }

    void setType(Type *Ty) { cTy = Ty; }

    virtual void print(bool nl = true);

    virtual uint32_t size() { return cTy ? cTy->size() : 0; };
};

class CompilationUnit
{

private:
    //    std::vector<CompilationFile> compFiles;
    std::vector<Type *> types;
    std::vector<Variable *> globals;
    std::vector<Function *> functions;

    std::map<std::string, std::vector<Variable *>> mglobals;
    std::map<std::string, std::vector<Function *>> mfunctions;

    CompilationUnit() {}

public:
    static CompilationUnit *createCU();

    void addFunction(Function *fun);

    void addVar(Variable *var);

    void addTypes(std::vector<Type *> tys) { types = tys; }

    Function *findFunction(std::string file, std::string name);
    Function *findFunByAddr(Addr addr);
    Function *findFunByLine(uint32_t line);
    Variable *findVar(std::string file, std::string name);
    std::vector<Variable *> getVars() { return globals; }
    std::vector<Function *> getFuns() { return functions; }

    void print();
};

/**
 *   Compilation File:
 *      Variables
 *      Functions
 *
 *
 */

class CompilationFile
{

private:
    std::vector<Variable *> globals;
    std::vector<Function *> functions;
};

enum Scope
{
    GLOBAL,
    FORMAL,
    LOCAL
};

/**
 *  scope : global , formal , local
 *  name
 *  loc
 */
class Variable
{
private:
    Scope scope;
    std::string _name;
    Type *type;

    std::string file;
    uint32_t line;
    /**
     * global: mem address
     * formal, local: offset  to  frame ptr reg
     *
     */
    uint64_t location;

public:
    Variable(Scope _scope, std::string name, Type *_type, std::string _file, uint32_t _line, uint64_t loc = 0) : scope(_scope), _name(name), type(_type), file(_file), line(_line), location(loc) {}

    std::string scopeStr(Scope s);
    Scope getScope() { return scope; }
    std::string getFile() { return file; }

    std::string getName() { return _name; }
    Type *getType() { return type; }
    uint64_t getLoc() { return location; }
    void print();
};

/**
 *  type: return type
 *  name
 *  paras , local vars
 *  address: [start,end]
 *  Line Number Table
 */

class Range
{
public:
    Addr start;
    Addr end;
    Range() {}
    Range(Addr _start, Addr _end) : start(_start), end(_end) {}
    bool include(Addr addr, bool includeEnd = true)
    {
        return start <= addr && (includeEnd ? end >= addr : end > addr);
    }
};

class Function
{

private:
    Type *type;
    std::string _name;
    std::vector<Variable *> vars;

    std::string file;
    uint32_t line;

    //Address range
    Range addrRange;

    //Line Number Tab
    std::map<uint32_t, Range> lnt;

    //tick range,用于随机定位,暂时未用到
    Range tickRange;

public:
    Function(Type *_type, std::string name, std::string _file, uint32_t _line, Range r) : type(_type), _name(name), file(_file), line(_line), addrRange(r) {}

    void addVar(Variable *var) { vars.push_back(var); }

    std::string getFile() { return file; }

    std::string getName() { return _name; }

    Range getRange() { return addrRange; }

    Range getTickRange() { return tickRange; }
    void setTickRange(Range tickRg) { tickRange = tickRg; }

    Variable *findVar(std::string name);
    uint32_t findLine(Addr addr);
    bool includeLine(uint32_t line);
    void setLNT(std::map<uint32_t, Range> _lnt) { lnt = _lnt; }
    void print();
};

#endif //TT_COMPILE_INFO_H

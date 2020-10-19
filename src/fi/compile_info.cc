//
// Created by zl on 2020/6/21.
//

#include "fi/compile_info.hh"
#include "fi/util.hh"
#include "base/trace.hh"

using namespace util;
using namespace std;
ArrayType::ArrayType(Type *bType, std::vector<uint32_t> subrgs) : baseType(bType), subranges(subrgs)
{
    uint32_t s = 1;
    for (unsigned i = 0; i < subranges.size(); i++)
        s *= subranges[i];

    if (baseType)
        _size = s * baseType->size();
    else
        _size = 0;
}

void BasicType::print(bool nl)
{
    const char *ename = 0;
    dwarf_get_ATE_name(_encoding, &ename);
    printf_d(1, "BasicTy ( name:  %s, size :%d , encoding :%s) ", _name.c_str(), _size, ename);
    if (nl)
        printf_d(1, "\n");
}

void ConstType::print(bool nl)
{
    printf_d(1, "Const ");
    if (cTy)
        cTy->print(false);
    if (nl)
        printf_d(1, "\n");
}

void VoidType::print(bool nl)
{
    printf_d(1, " void ");
    if (nl)
        printf_d(1, "\n");
}

void PtrType::print(bool nl)
{
    printf_d(1, " Ptr ");
    if (baseType)
        baseType->print(false);
    if (nl)
        printf_d(1, "\n");
}

void ArrayType::print(bool nl)
{
    printf_d(1, "Array Type( ");
    if (baseType)
        baseType->print(false);
    printf_d(1, " ,size : %d , ", _size);
    printf_d(1, "elements subranges{ ");
    for (int i = 0; i < subranges.size(); ++i)
    {
        printf_d(1, " %d ,", subranges[i]);
    }

    printf_d(1, "}  )");
    if (nl)
        printf_d(1, "\n");
}

uint32_t StructType::size()
{
    if (_size > 0)
        return _size;
    for (uint32_t i = 0; i < _chs.size(); i++)
        _size += _chs[i]->getType() ? _chs[i]->getType()->size() : 0;

    return _size;
}

void StructType::print(bool nl)
{
    printf_d(1, "Struct  ");
    if (nl)
        printf_d(1, "\n");
}

void TypeDefType::print(bool nl)
{
    printf_d(1, "typedef  ");
    if (cTy)
        cTy->print(false);
    if (nl)
        printf_d(1, "\n");
}

CompilationUnit *CompilationUnit::createCU()
{
    CompilationUnit *cu = new CompilationUnit();
    return cu;
}

void CompilationUnit::addFunction(Function *fun)
{
    functions.push_back(fun);
    string fname = fun->getFile();
    if (mfunctions.find(fun->getFile()) != mfunctions.end())
    {
        vector<Function *> fList = mfunctions.find(fname)->second;
        fList.push_back(fun);
        mfunctions.erase(fname);
        mfunctions.insert(pair<string, vector<Function *>>(fname, fList));
    }
    else
    {

        vector<Function *> fList;
        fList.push_back(fun);
        mfunctions.insert(pair<string, vector<Function *>>(fname, fList));
    }
}

void CompilationUnit::addVar(Variable *var)
{
    globals.push_back(var);
    string vname = var->getFile();
    if (mglobals.find(var->getFile()) != mglobals.end())
    {
        vector<Variable *> vList = mglobals.find(vname)->second;
        vList.push_back(var);
        mglobals.erase(vname);
        mglobals.insert(pair<string, vector<Variable *>>(vname, vList));
    }
    else
    {

        vector<Variable *> vList;
        vList.push_back(var);
        mglobals.insert(pair<string, vector<Variable *>>(vname, vList));
    }
}

Function *CompilationUnit::findFunction(std::string file, std::string name)
{
    Function *res = nullptr;
    if (file == "")
    {
        map<std::string, std::vector<Function *>>::iterator it = mfunctions.begin();
        for (; it != mfunctions.end(); it++)
        {
            vector<Function *> flist = it->second;
            for (size_t i = 0; i < flist.size(); i++)
            {
                if (flist[i]->getName() == name)
                    return flist[i];
            }
        }
    }
    else
    {
        map<std::string, std::vector<Function *>>::iterator it = mfunctions.find(file);
        if (it != mfunctions.end())
        {
            vector<Function *> flist = it->second;
            for (size_t i = 0; i < flist.size(); i++)
            {
                if (flist[i]->getName() == name)
                    return flist[i];
            }
        }
    }

    return res;
}
Function *CompilationUnit::findFunByAddr(Addr addr)
{

    map<std::string, std::vector<Function *>>::iterator it = mfunctions.begin();
    for (; it != mfunctions.end(); it++)
    {
        vector<Function *> flist = it->second;
        for (size_t i = 0; i < flist.size(); i++)
        {
            if (flist[i]->getRange().include(addr, false))
                return flist[i];
        }
    }
    return nullptr;
}

Function *CompilationUnit::findFunByLine(uint32_t line)
{
    map<std::string, std::vector<Function *>>::iterator it = mfunctions.begin();
    for (; it != mfunctions.end(); it++)
    {

        vector<Function *> flist = it->second;
        for (size_t i = 0; i < flist.size(); i++)
        {
            if (flist[i]->includeLine(line))
                return flist[i];
        }
    }
    return nullptr;
}

Variable *CompilationUnit::findVar(std::string file, std::string name)
{
    Variable *res = nullptr;
    if (file == "")
    {
        map<std::string, std::vector<Variable *>>::iterator it = mglobals.begin();
        for (; it != mglobals.end(); it++)
        {
            vector<Variable *> vlist = it->second;
            for (size_t i = 0; i < vlist.size(); i++)
            {
                if (vlist[i]->getName() == name)
                    return vlist[i];
            }
        }
    }
    else
    {
        map<std::string, std::vector<Variable *>>::iterator it = mglobals.find(file);
        if (it != mglobals.end())
        {
            vector<Variable *> vlist = it->second;
            for (size_t i = 0; i < vlist.size(); i++)
            {
                if (vlist[i]->getName() == name)
                    return vlist[i];
            }
        }
    }

    return res;
}

void CompilationUnit::print()
{

    printf_d(1, "\nCompilationUnit:  \n");

    // for (int i = 0; i < types.size(); ++i)
    // {
    //     types[i]->print();
    // }
    for (int i = 0; i < globals.size(); ++i)
    {
        globals[i]->print();
    }
    for (int i = 0; i < functions.size(); ++i)
    {
        functions[i]->print();
    }
}
Variable *Function::findVar(std::string name)
{
    uint32_t size = vars.size();
    for (uint32_t i = 0; i < size; ++i)
    {
        if (vars[i]->getName() == name)
            return vars[i];
    }
    return nullptr;
}

uint32_t Function::findLine(Addr addr)
{
    uint32_t line = -1;
    for (auto it = lnt.begin(); it != lnt.end(); it++)
    {
        if (it->second.include(addr))
        {
            return it->first;
        }
    }
    return line;
}

bool Function::includeLine(uint32_t line)
{

    uint32_t begin = lnt.begin()->first;
    uint32_t end = (--lnt.end())->first;

    return begin <= line && end >= line;
}

void Function::print()
{

    printf_d(1, "\nFunction :\n");

    printf_d(1, "\tname: %s\n", _name.c_str());

    printf_d(1, "\tType:  ");
    if (type)
        type->print();

    printf_d(1, "\tfile: %s\n", file.c_str());
    printf_d(1, "\tline: %d\n", line);

    printf_d(1, "\tAddress Range: [0x%x,0x%x]\n", addrRange.start, addrRange.end);

    for (int i = 0; i < vars.size(); ++i)
    {
        vars[i]->print();
    }
}

string Variable::scopeStr(Scope s)
{

    switch (s)
    {
    case GLOBAL:
        return "GLOBAL";
    case FORMAL:
        return "FORMAL";
    case LOCAL:
        return "LOCAL";
    default:
        return "ERROR";
    }
}

void Variable::print()
{

    printf_d(1, "\n  Variable :\n");

    printf_d(1, "\tname: %s\n", _name.c_str());

    printf_d(1, "\tType:");
    if (type)
        type->print();

    printf_d(1, "\tScope: %s\n", scopeStr(scope).c_str());

    printf_d(1, "\tfile: %s\n", file.c_str());

    printf_d(1, "\tline: %d\n", line);

    printf_d(1, "\tlocation: %d\n", location);
}

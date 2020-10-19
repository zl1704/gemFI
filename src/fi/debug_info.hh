//
// Created by zl on 2020/6/17.
//

#ifndef __DEBUG_INFO_HH_
#define __DEBUG_INFO_HH_

#include <libdwarf.h>
#include <string.h>
#include <vector>
#include <map>
#include <elf.h>
#include <fstream>

#include "fi/compile_info.hh"

typedef uint64_t TAG;
typedef uint64_t AT;
typedef uint64_t FORM;
typedef uint64_t CODE;

enum BIT
{
    BIT64,
    BIT32
};

enum ENDIAN
{
    BIG,
    LITTLE
};

enum MACHINE
{

    X32,
    X64,
    ARM32,
    ARM64,
    UNKNOWN

};

//Buf Object

class BufObj
{
public:
    //constant
    const static uint8_t SIZETYPE_DATA1 = 1;
    const static uint8_t SIZETYPE_DATA2 = SIZETYPE_DATA1 + 1;
    const static uint8_t SIZETYPE_DATA4 = SIZETYPE_DATA2 + 2;
    const static uint8_t SIZETYPE_DATA8 = SIZETYPE_DATA4 + 4;

    //LEB128
    const static uint8_t SIZETYPE_ULEB128 = SIZETYPE_DATA8 + 1;
    const static uint8_t SIZETYPE_SLEB128 = SIZETYPE_ULEB128 + 1;

    const static uint8_t SIZETYPE_PRESENT = SIZETYPE_SLEB128 + 1;
    const static uint8_t SIZETYPE_STRINGCONST = SIZETYPE_PRESENT + 1;
    const static uint8_t SIZETYPE_BLOCK = SIZETYPE_STRINGCONST + 1;
    const static uint8_t SIZETYPE_BLOCK1 = SIZETYPE_BLOCK + 1;
    const static uint8_t SIZETYPE_BLOCK2 = SIZETYPE_BLOCK1 + 1;

    const static uint8_t SIZETYPE_BLOCK4 = SIZETYPE_BLOCK2 + 2;

    const static uint8_t SIZETYPE_EXERLOC = SIZETYPE_BLOCK;

    //String constant

    const static uint8_t SIZETYPE_ERROR = SIZETYPE_PRESENT + 1;

    void advance(int16_t size);

    uint64_t readData(uint8_t sizetype);

    char *getPtr() { return buf + bp; }

protected:
    char *buf;
    uint64_t bp;
    uint64_t bsize;

public:
    BufObj(char *data, uint64_t _bp = 0, uint64_t _size = 16)
    {
        buf = data;
        bp = _bp;
        bsize = _size;
    }
};

//Debug Abbrev
//Attr Type
class AttrEntry
{
public:
    AT attrType;
    FORM form;

    AttrEntry(AT at, FORM _form) : attrType(at), form(_form)
    {
    }
};

class TagEntry
{
private:
    CODE code;
    TAG tag;
    bool has_children;
    std::vector<AttrEntry *> attrList;

public:
    TagEntry(CODE _code, TAG _tag, bool has_child) : code(_code), tag(_tag), has_children(has_child) {}

    void addEntry(AttrEntry *ae) { attrList.push_back(ae); }

    TAG getTAG() { return tag; }
    bool hasChildren() { return has_children; }
    void print();

    std::vector<AttrEntry *> getEntries() { return attrList; }
};

class AbbrevTable : public BufObj
{
private:
    std::vector<std::vector<TagEntry *>> eList;

    AbbrevTable(char *_debug_abbrev, uint32_t size) : BufObj(_debug_abbrev, 0, size) {}

    void init();

public:
    static AbbrevTable *createAbbrevTable(char *debug_abbrev, uint32_t size);
    TagEntry *readTagEntry(CODE code);

    std::vector<TagEntry *> getEntries(int index) { return eList[index]; }
    uint32_t getCUNum() { return eList.size(); }
};

class DITable;

class DIEntry;

class DebugInfo;

class DIATEntry
{

    friend class DIEntry;

private:
    AttrEntry *abbrev;
    std::vector<uint64_t> values;
    char *strval;

    DITable *diTable;

    char *getStrVal();

public:
    DIATEntry(AttrEntry *_abbrev, DITable *_diTable) : abbrev(_abbrev), diTable(_diTable)
    {
        strval = 0;
    }

    void readValue(DITable *dit);

    void print();
};

//Debug Info Entry
class DIEntry
{
    friend class DITable;

private:
    CODE code;
    std::vector<DIATEntry *> eList;
    std::vector<DIEntry *> children;
    bool has_children;

public:
    DIEntry(CODE _code, bool has_ch) : code(_code), has_children(has_ch)
    {
    }

    uint64_t getATValue(AT at);

    std::string getATStrValue(AT at);
    std::vector<DIEntry *> getChildren() { return children; };
    CODE getCode() { return code; }
};

class DITable : public BufObj
{

private:
    friend class DIATEntry;
    friend class DebugInfo;

    uint64_t length;
    uint16_t version;
    uint64_t abbrev_offset;
    uint8_t address_size;
    std::vector<DIEntry *> eList;
    std::vector<std::vector<DIEntry *>> cus;
    std::map<uint32_t, DIEntry *> refTypes;
    std::vector<std::map<uint32_t, DIEntry *>> tys;
    bool is_64bit;
    AbbrevTable *abbrevTable;
    DebugInfo *di;

    uint32_t offset;
    uint32_t cu_index;
    DITable(char *_data, AbbrevTable *_abbrevTable);
    void init();

    void processAbbrevTable();

    char *getData() { return buf + bp; }
    DIEntry *readDIEInfo();
    DIEntry *readDIE();
    void readDIEList(std::vector<DIEntry *> &DIEs);
    void readCUList();

public:
    uint8_t getFormDataSize(FORM form);

    static DITable *createDITable(char *debug_info, AbbrevTable *abbrevTable, DebugInfo *di);

    std::vector<DIEntry *> getDIEntries(uint32_t index) { return cus[index]; }

    uint32_t getCUNum() { return cus.size(); }

    std::map<uint32_t, DIEntry *> getRefTypes(uint32_t index) { return tys[index]; }

    std::map<uint32_t, DIEntry *> getRefTypes() { return refTypes; }

    char *getStrVal(uint64_t index);
};

class LineInfo
{
public:
    uint32_t file;
    uint32_t line;

    //Address
    Addr start;
    Addr end;

    LineInfo() {}

    LineInfo(uint32_t _file, uint32_t _line, uint64_t _start, uint64_t _end) : file(_file), line(_line), start(_start),
                                                                               end(_end) {}
};

//Debug Line Talbe
class DLTable : public BufObj
{
private:
#define STDOPLEN 12
#pragma pack(1)
    typedef struct
    {
        uint32_t length;
        uint16_t version;
        uint32_t header_length;
        uint8_t min_instruction_length;
        uint8_t maximum_operations_per_instruction;
        uint8_t default_is_stmt;
        int8_t line_base;
        uint8_t line_range;
        uint8_t opcode_base;
        uint8_t *std_opcode_lengths; //opcode_base - 1  opcode可能会扩展
    } DebugLineHeader;               // 27
#pragma pack()

    typedef struct
    {
        std::string name;
        uint64_t dir;
        uint64_t time;
        uint64_t size;

    } FileInfo;

    class StateMachine : public BufObj
    {

    private:
        uint64_t address;
        uint8_t file;
        uint32_t line;
        uint8_t col; //不用;
        bool is_stmt;
        bool is_bb;
        bool is_endseq;
        uint8_t min_instruction_length;
        int8_t line_base;
        uint8_t line_range;
        uint8_t opcode_base;

        uint8_t op;
        DLTable *dlTable;

        LineInfo curLine;
        std::vector<LineInfo> lines;
        enum CODETYPE
        {

            STANDARD,
            EXTENDED,
            SPECIAL
        };

        enum CODETYPE CodeType(uint8_t op);

        //Standard Code
        void processStd();

        //Special Code
        void processSpecial();

        //Extended Code
        void processExt();

        //生成一行信息
        void genLine();

        uint32_t addrInc(uint8_t op)
        {
            return ((op - opcode_base) / line_range) * min_instruction_length;
        }

        uint32_t lineInc(uint8_t op)
        {
            return line_base + (op - opcode_base) % line_range;
        }

        StateMachine(char *buf) : BufObj(buf)
        {
        }

    public:
        static StateMachine *createSM(DebugLineHeader *dlh, char *buf, DLTable *dlTable);

        void doProcess();
    };

    std::vector<FileInfo> fileTable;
    std::vector<std::string> dirTable;
    DebugLineHeader *dlh;
    DebugInfo *di;

    std::map<uint32_t, std::vector<LineInfo>> flinetabs;

    void addFileLineTable(uint32_t file, std::vector<LineInfo> lines);

    DLTable(char *debug_line, DebugInfo *di);
    void readHeader();
    // file : lineinfo
    void doProcess();

public:
    void printLineNumber();
    std::string getFileName(uint32_t fno);
    std::map<uint32_t, Range> extractLNT(Range addrRange);
    BIT getBitWidth();
    static DLTable *createDLTable(char *debug_line, DebugInfo *di);
};

class ELFHeader
{

public:
    BIT bitType;
    ENDIAN endian;
    MACHINE machine;
    uint64_t phoff; // program header offset
    uint64_t shoff; // section header offset
    uint16_t phnum;
    uint16_t shnum;
    uint16_t phsize;
    uint16_t shsize;

    uint16_t shstrndx;
    uint16_t size; // size of header
    ELFHeader();
};

class SectionHeader
{
public:
    uint32_t sh_name; //string tbl index
    uint32_t sh_type;
    uint32_t sh_size;
    uint64_t sh_offset;
    SectionHeader()
    {
        sh_name = 0;
        sh_type = 0;
        sh_offset = 0;
    }
};

class DebugInfo
{

private:
    ELFHeader elfHeader;

    //debug_info
    DITable *diTable;

    //debug_abbrev
    AbbrevTable *abbrevTable;

    //debug_line
    DLTable *dlTable;

    std::ifstream ifs;

    //debug_str
    char *strTable;

    std::map<uint32_t, Type *> mtypes;
    size_t index;

    uint32_t cu_index;
    DebugInfo()
    {
        diTable = nullptr;
        abbrevTable = nullptr;
        dlTable = nullptr;
        strTable = nullptr;
        cu_index = 0;
    }

    void init(std::string file);
    void readELFHeader();
    char *readShData(SectionHeader shdr);
    SectionHeader readSectionHeader(uint32_t offset);

    void createTabs(char *shstrtab);

    Function *genFunction();
    Variable *genVar(DIEntry *die, TAG tag);
    ArrayType *createArrayType(DIEntry *die);
    StructType *createStructType(StructType *sTy, DIEntry *die);

public:
    static DebugInfo *createDebugInfo(char *debug_info, char *debug_abbrev, char *debug_line, char *debug_str);

    static DebugInfo *create(std::string file);

    char *getStrVal(uint64_t index) { return strTable + index; }

    CompilationUnit *genCU();
    void genCUList(std::vector<CompilationUnit *> &clist);

    BIT getBitWidth() { return elfHeader.bitType; }
};

#endif //__DEBUG_INFO_HH_

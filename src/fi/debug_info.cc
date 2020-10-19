//
// Created by zl on 2020/6/17.
//
#include <dwarf.h>

#include "fi/debug_info.hh"
#include "fi/compile_info.hh"
#include "fi/util.hh"
#include "base/trace.hh"
using namespace std;
using namespace util;

/**
 *
 * @param size
 *  1  2  4  8 LEB128
 *
 *
 *
 * @return
 */
uint64_t BufObj::readData(uint8_t size)
{

    uint64_t res;
    int64_t sres;
    uint8_t ss = size;
    switch (size)
    {

    case SIZETYPE_DATA1:
        res = *(uint8_t *)(buf + bp);
        break;
    case SIZETYPE_DATA2:
        res = *(uint16_t *)(buf + bp);
        break;
    case SIZETYPE_DATA4:
        res = *(uint32_t *)(buf + bp);
        break;
    case SIZETYPE_DATA8:
        res = *(uint64_t *)(buf + bp);
        break;
    case SIZETYPE_ULEB128:
        ss = leb128u((buf + bp), res);
        break;
    case SIZETYPE_SLEB128:
        ss = leb128s((buf + bp), sres);
        res = sres;
        break;
    default:
        break;
    }
    if (bp + ss > bsize)
    {
        fprintf(stderr, "size over buf size!");
        exit(1);
    }
    advance(ss);

    return res;
}

ELFHeader::ELFHeader()
{
    bitType = BIT32;
    endian = LITTLE;
    machine = X64;
    phoff = 0;
    shoff = 0;
    phnum = 0;
    shnum = 0;
    phsize = 0;
    shsize = 0;
    shstrndx = 0;
    size = 0;
}

void BufObj::advance(int16_t size)
{

    bp += size;
    //    buf += size;
}

void TagEntry::print()
{
    printf_d(2, "TagEntry [code = %d , tag = 0x%x , has_children = %d]\n", code, tag, has_children);
}

void DIATEntry::print()
{

    const char *ATName = 0;
    dwarf_get_AT_name(abbrev->attrType, &ATName);
    printf_d(2, "\t %s :  ", ATName);
    uint64_t size = values.size();
    if (size > 1)
    {
        printf_d(2, "%d byte block : ", size);
        for (int i = 0; i < size; ++i)
        {
            printf_d(2, " %x ", values[i]);
        }
    }
    else if (size == 1)
        printf_d(2, "%d  ", values[0]);
    else
        printf_d(2, " %s ", strval);
    printf_d(2, "\n");
}

void DIATEntry::readValue(DITable *dit)
{

    uint8_t sizetype = dit->getFormDataSize(abbrev->form);

    uint64_t len = 0;

    //once read
    if (sizetype <= BufObj::SIZETYPE_SLEB128)
    {
        values.push_back(dit->readData(sizetype));
    }
    else if (sizetype == BufObj::SIZETYPE_PRESENT)
        values.push_back(1);
    else if (sizetype == BufObj::SIZETYPE_STRINGCONST)
    {
        strval = dit->getData();
        dit->readData(strlen(strval) + 1);
    }
    else if (sizetype <= BufObj::SIZETYPE_BLOCK4)
    {
        if (sizetype == BufObj::SIZETYPE_BLOCK)
            len = dit->readData(BufObj::SIZETYPE_ULEB128);
        else
            len = dit->readData(sizetype - BufObj::SIZETYPE_BLOCK);

        while (len--)
            values.push_back(dit->readData(BufObj::SIZETYPE_DATA1));
    }
    if(abbrev->attrType == DW_AT_type)
        values[0] = values[0]+dit->offset;
}

char *DIATEntry::getStrVal()
{
    if (strval)
        return strval;
    strval = diTable->getStrVal(values[0]);
    return strval;
}

AbbrevTable *AbbrevTable::createAbbrevTable(char *debug_abbrev, uint32_t size)
{
    AbbrevTable *abbrevTable = new AbbrevTable(debug_abbrev, size);
    abbrevTable->init();
    return abbrevTable;
}

TagEntry *AbbrevTable::readTagEntry(CODE code)
{
    TAG tag;
    bool has_children;
    //    AttrEntry *attrEntry;
    TagEntry *tagEntry;
    AT aname;
    FORM form;
    const char *ATName = 0;
    const char *FormName = 0;
    tag = readData(SIZETYPE_ULEB128);
    has_children = readData(SIZETYPE_DATA1);
    tagEntry = new TagEntry(code, tag, has_children);
    aname = readData(SIZETYPE_ULEB128);
    form = readData(SIZETYPE_ULEB128);

    tagEntry->print();

    /**
     * <name,form>
     * <name,form>
     *   ...
     *  <0  , 0 >
     */
    while (aname && form)
    {
        dwarf_get_AT_name(aname, &ATName);
        dwarf_get_FORM_name(form, &FormName);
        //debug
        printf_d(2, "\t[0x%x]: AttrEntry[ NAME = 0x%x (%s) , FORM = 0x%x (%s) ] \n", bp, aname, ATName, form, FormName);

        tagEntry->addEntry(new AttrEntry(aname, form));
        aname = readData(SIZETYPE_ULEB128);
        form = readData(SIZETYPE_ULEB128);
    }

    return tagEntry;
}

void AbbrevTable::init()
{
    CODE code;
    /**
     * code
     * tag
     * has_children
     */
    std::vector<TagEntry *> tlist;

    while (bp < bsize)
    {
        //        code = readData(SIZETYPE_ULEB128);
        tlist.push_back(new TagEntry(0, -1, 0));
        while ((code = readData(SIZETYPE_ULEB128)))
        {

            tlist.push_back(readTagEntry(code));
        }
        eList.push_back(tlist);
        tlist.clear();
    }
}

uint64_t valMerge(vector<uint64_t> vals, uint32_t start)
{
    uint64_t res = 0;
    for (int i = start, j = 0; i < vals.size(); ++i, ++j)
    {
        res |= vals[i] << (8 * j);
    }
    return res;
}

uint64_t DIEntry::getATValue(AT at)
{

    DIATEntry *ate = nullptr;

    for (size_t i = 0; i < eList.size(); i++)
    {
        if (eList[i]->abbrev->attrType == at)
        {
            ate = eList[i];
            break;
        }
    }

    if (!ate)
        return 0;

    if (at == DW_AT_location)
    {
        uint8_t op = ate->values[0];
        if (op == DW_OP_fbreg)
        {
            uint64_t val = valMerge(ate->values, 1);
            int64_t res = 0;
            leb128s((char *)&val, res);
            return res;
        }
        else if (op == DW_OP_addr)
        {
            uint64_t val = valMerge(ate->values, 1);
            uint64_t res = val;
            //            leb128u((char *) &val, res);
            return res;
        }

        return 0;
    }
    else
    {
        return ate->values[0];
    }
}
string DIEntry::getATStrValue(AT at)
{
    DIATEntry *ate = nullptr;
    for (size_t i = 0; i < eList.size(); i++)
    {
        if (eList[i]->abbrev->attrType == at)
        {
            ate = eList[i];
            break;
        }
    }

    if (!ate)
        return "";
    FORM form = ate->abbrev->form;
    if (form == DW_FORM_string)
    {

        return ate->strval;
    }
    else if (form == DW_FORM_strp)
    {

        return ate->getStrVal();
    }
    return "";
}

DITable::DITable(char *_data, AbbrevTable *_abbrevTable) : BufObj(_data), abbrevTable(_abbrevTable)
{
    cu_index = 0;
}

DITable *DITable::createDITable(char *debug_info, AbbrevTable *abbrevTable, DebugInfo *di)
{

    DITable *diTable = new DITable(debug_info, abbrevTable);
    diTable->di = di;
    diTable->readCUList();

    return diTable;
}

void DITable::init()
{
    /**
     * Length :       4B or 8B
     * Version:       uHalf
     * abbrev_offset: 4B or 8B
     * address_size:  1Bu
     *
     * abbrevTable
     */
    uint32_t len_32 = 0;
    offset = bp;
    bsize += 8;
    is_64bit = false;
    len_32 = readData(4);
    length = len_32;
    if (len_32 == 0xFFFFFFFF)
    {
        length = readData(8);
        is_64bit = true;
    }
    bsize += length;
    version = readData(2);
    //    advanceData(2);

    if (is_64bit)
    {
        abbrev_offset = readData(8);
    }
    else
    {
        abbrev_offset = readData(4);
    }

    address_size = readData(1);
}

uint8_t DITable::getFormDataSize(FORM form)
{
    switch (form)
    {

    case DW_FORM_addr:
        return address_size == 8 ? SIZETYPE_DATA8 : SIZETYPE_DATA4;

    case DW_FORM_ref1:
    case DW_FORM_flag:
    case DW_FORM_data1: //constant
        return SIZETYPE_DATA1;

    case DW_FORM_ref2:
    case DW_FORM_data2:
        return SIZETYPE_DATA2;

    case DW_FORM_ref4:
    case DW_FORM_data4:
        return SIZETYPE_DATA4;

    case DW_FORM_ref_sig8:
    case DW_FORM_ref8:
    case DW_FORM_data8:
        return SIZETYPE_DATA8;

    case DW_FORM_ref_udata:
    case DW_FORM_udata:
        return SIZETYPE_ULEB128;
    case DW_FORM_sdata:
        return SIZETYPE_SLEB128;

    case DW_FORM_ref_addr:
    case DW_FORM_sec_offset: //ptr

    case DW_FORM_strp:
        return is_64bit ? SIZETYPE_DATA8 : SIZETYPE_DATA4;
    case DW_FORM_string: //立即字符串
        return SIZETYPE_STRINGCONST;
    case DW_FORM_indirect: //
        return SIZETYPE_DATA8;
    case DW_FORM_flag_present:
        return SIZETYPE_PRESENT;
    case DW_FORM_exprloc:
        return SIZETYPE_EXERLOC;
    case DW_FORM_block1: // 0～ 255B followed
        return SIZETYPE_BLOCK1;
    case DW_FORM_block2:
        return SIZETYPE_BLOCK2;
    case DW_FORM_block4:
        return SIZETYPE_BLOCK4;
    case DW_FORM_block:
        return SIZETYPE_BLOCK;

    default:
        const char *formName = 0;

        dwarf_get_FORM_name(form, &formName);
        fprintf(stderr, "Unhandled Form: %s \n", formName);
        exit(1);
    }
}

bool isTypeTag(TAG tag)
{
    switch (tag)
    {
    case DW_TAG_base_type:
    case DW_TAG_pointer_type:
    case DW_TAG_array_type:
    case DW_TAG_typedef:
    case DW_TAG_const_type:
    case DW_TAG_structure_type:
        return true;
    default:
        return false;
    }
}

DIEntry *DITable::readDIEInfo()
{
    vector<TagEntry *> tList = abbrevTable->getEntries(cu_index);
    //    uint32_t tsize = tList.size();
    CODE code;

    uint64_t curbp = bp;
    code = readData(SIZETYPE_ULEB128);
    if (!code)
        return nullptr;
    const char *tname = 0;
    //        if (!code) {
    //            printf_d(2,"  Abbrev Number: %d (%s)\n", code, name);
    //            code = readData(SIZETYPE_ULEB128);
    //            continue;
    //        }
    TAG tag = tList[code]->getTAG();
    dwarf_get_TAG_name(tag, &tname);
    printf_d(2, " <%d> Abbrev Number: %d (%s)\n", curbp, code, tname);
    vector<AttrEntry *> aList = tList[code]->getEntries();
    uint32_t asize = aList.size();

    DIEntry *die = new DIEntry(code, tList[code]->hasChildren());
    DIATEntry *ate;
    for (int j = 0; j < asize; ++j)
    {
        ate = new DIATEntry(aList[j], this);
        ate->readValue(this);
        ate->print();
        die->eList.push_back(ate);
    }

    if (isTypeTag(tag))
        refTypes.insert(pair<uint32_t, DIEntry *>(curbp, die));

    eList.push_back(die);
    return die;
}

void DITable::readDIEList(std::vector<DIEntry *> &DIEs)
{

    DIEntry *die = nullptr;
    while ((die = readDIE()) != nullptr)
    {
        DIEs.push_back(die);
    }
}

DIEntry *DITable::readDIE()
{

    DIEntry *die = readDIEInfo();
    if (!die)
        return die;
    if (die->has_children)
    {
        readDIEList(die->children);
    }

    return die;
}
void DITable::readCUList()
{
    cus.clear();

    for (uint32_t i = 0, e = abbrevTable->getCUNum(); i < e; ++i)
    {
        cu_index = i;
        eList.clear();
        refTypes.clear();

        init();
        //Abbrev Table
        processAbbrevTable();
        cus.push_back(eList);
        tys.push_back(refTypes);
    }
}

void DITable::processAbbrevTable()
{

    printf_d(2, " \n  ===== processAbbrevTable ====\n ");

    readDIE();
}
void DLTable::readHeader()
{
    bp = 0;
    dlh = new DebugLineHeader;
    dlh->length = *(uint32_t *)getPtr();
    bsize = dlh->length + 4;
    advance(4);
    dlh->version = readData(2);
    dlh->header_length = readData(4);
    dlh->min_instruction_length = readData(1);
    if (dlh->version == 4)
        dlh->maximum_operations_per_instruction = readData(1);
    dlh->default_is_stmt = readData(1);
    dlh->line_base = readData(1);
    dlh->line_range = readData(1);
    dlh->opcode_base = readData(1);
    dlh->std_opcode_lengths = new uint8_t[dlh->opcode_base];
    // dlh->std_opcode_lengths = new uint8_t[12];
    for (uint8_t i = 0; i < dlh->opcode_base - 1; ++i)
        dlh->std_opcode_lengths[i] = readData(1);
}
void DLTable::doProcess()
{
    printf_d(2, " ====== process Debug Line ========\n");
    readHeader();
    char *p;
    string name;

    //dirs
    while (*(p = getPtr()))
    {
        name = p;
        dirTable.push_back(name);
        advance(name.size() + 1);
    }

    advance(1);

    //files
    while (*(p = getPtr()))
    {
        name = p;
        FileInfo fi;
        fi.name = name;
        advance(name.size() + 1);
        advance(leb128u(getPtr(), fi.dir));
        advance(leb128u(getPtr(), fi.time));
        advance(leb128u(getPtr(), fi.size));
        fileTable.push_back(fi);
    }

    advance(1);

    StateMachine *sm = StateMachine::createSM(dlh, getPtr(), this);
    sm->doProcess();
}

char *DITable::getStrVal(uint64_t index)
{
    return di->getStrVal(index);
}

string DLTable::getFileName(uint32_t fno)
{
    if (!fno || fno > fileTable.size())

        return "";

    return fileTable[fno - 1].name;
}

void DLTable::addFileLineTable(uint32_t file, std::vector<LineInfo> lines)
{

    flinetabs.insert(pair<uint32_t, vector<LineInfo>>(file, lines));
}

void DLTable::printLineNumber()
{

    // map<uint32_t, vector<LineInfo>>::iterator fit = flinetabs.begin();
    // for (; fit != flinetabs.end(); fit++)
    // {
    //     string filename = getFileName(fit->first);
    //     vector<LineInfo> lines = fit->second;
    //     printf_d(2, "\n\t [%s] \n", filename.c_str());
    //     for (uint32_t i = 0; i < lines.size(); i++)
    //     {
    //         LineInfo li = lines[i];

    //         printf_d(2, "\t %d %10x %10x\n ", li.line, li.start, li.end);
    //     }
    // }
}

map<uint32_t, Range> DLTable::extractLNT(Range addrRange)
{

    map<uint32_t, vector<LineInfo>>::iterator fit = flinetabs.begin();
    map<uint32_t, Range> lnt;
    for (; fit != flinetabs.end(); fit++)
    {
        vector<LineInfo> lines = fit->second;
        for (uint32_t i = 0; i < lines.size(); i++)
        {
            LineInfo li = lines[i];
            if (addrRange.include(li.start))
            {
                lnt.insert(pair<uint32_t, Range>(li.line, Range(li.start, li.end)));
            }
        }
    }

    return lnt;
}

DLTable::DLTable(char *debug_line, DebugInfo *_di) : BufObj(debug_line), di(_di)
{
}

DLTable *DLTable::createDLTable(char *debug_line, DebugInfo *di)
{
    DLTable *dlTable = new DLTable(debug_line, di);
    dlTable->doProcess();
    return dlTable;
}
BIT DLTable::getBitWidth()
{
    return di->getBitWidth();
}

//Extended Code
void DLTable::StateMachine::processExt()
{
    uint64_t len = 0;
    uint8_t eop = 0;
    len = readData(SIZETYPE_ULEB128);
    eop = readData(SIZETYPE_DATA1);
    if (eop == DW_LNE_set_address)
    {
        //长度要判断下
        if (dlTable->getBitWidth() == BIT32)
        {
            address = readData(SIZETYPE_DATA4);
            advance(-4);
        }
        else
        {
            address = readData(SIZETYPE_DATA8);
            advance(-8);
        }
        printf_d(2, "\tExtended Opcode 2 :  set Addr = 0x%x \n", address);
    }
    else if (eop == DW_LNE_end_sequence)
    {
        printf_d(2, "\tExtended Opcode 1 : End of sequence \n");
        dlTable->addFileLineTable(file, lines);
    }
    advance(len - 1);
}

//Standard Code
void DLTable::StateMachine::processStd()
{
    //    uint8_t op = readData(SIZETYPE_DATA1);
    uint64_t inc = 0;
    int64_t sinc = 0;
    uint8_t adv = 0;

    switch (op)
    {
    case DW_LNS_copy:
        //生成一行信息
        printf_d(2, "\tCopy...\n");
        break;
    case DW_LNS_advance_pc:
        inc = readData(SIZETYPE_ULEB128);
        printf_d(2, "\tAddress inc %d: from 0x%x to 0x%x\n", inc, address, address + inc);
        address += inc;
        break;
    case DW_LNS_advance_line:
        sinc = readData(SIZETYPE_SLEB128);
        printf_d(2, "\tLine inc %d: from %d to %d\n", inc, line, line + sinc);
        line += sinc;
        break;
    case DW_LNS_set_file:
        sinc = readData(SIZETYPE_SLEB128);
        printf_d(2, "\tSet file = %d\n", inc);
        file = sinc;
        break;
    case DW_LNS_set_column:
        inc = readData(SIZETYPE_ULEB128);
        printf_d(2, "\tSet Column = %d\n", inc);
        col = inc;
        break;
    case DW_LNS_negate_stmt:
        printf_d(2, "\t Set stmt \n");
        is_stmt = !is_stmt;
        break;
    case DW_LNS_set_basic_block:
        printf_d(2, "\t Set Basic Block \n");
        is_bb = true;
        break;
    case DW_LNS_const_add_pc:
        inc = addrInc(255);
        printf_d(2, "\tAddress inc Const %d: from 0x%x to 0x%x\n", inc, address, address + inc);
        address += inc;
        break;
    case DW_LNS_fixed_advance_pc:
        inc = readData(SIZETYPE_DATA4);
        printf_d(2, "\tAddress inc Fixed %d: from 0x%x to 0x%x\n", inc, address, address + inc);
        break;
    case DW_LNS_set_prologue_end:
        printf_d(2, "\tSet Prologue_end\n");
        break;
    case DW_LNS_set_epilogue_begin:
        printf_d(2, "\tSet epilogue_begin\n");
        break;
    case DW_LNS_set_isa:
        readData(SIZETYPE_ULEB128);
        printf_d(2, "\tSet Isa Register \n");
        break;
    }

    advance(adv);
}

//Special Code
void DLTable::StateMachine::processSpecial()
{
    curLine.file = file;
    curLine.line = line;
    curLine.start = address;
    uint32_t aInc = addrInc(op);
    uint32_t lInc = lineInc(op);

    printf_d(2, "\tSpecial Code : %d : Addr Inc (%d) (0x%x -> 0x%x) , Line Inc (%d) (%d -> %d)\n", op, aInc, address,
             address + aInc, lInc, line, line + lInc);
    address += aInc;
    line += lInc;
    curLine.end = address;
    genLine();
}

void DLTable::StateMachine::genLine()
{

    lines.push_back(curLine);
}

DLTable::StateMachine::CODETYPE DLTable::StateMachine::CodeType(uint8_t op)
{

    if (!op)
        return EXTENDED;

    if (op < opcode_base)
        return STANDARD;

    return SPECIAL;
}

void DLTable::StateMachine::doProcess()
{
    while (bp < bsize)
    {
        switch (CodeType(op = readData(SIZETYPE_DATA1)))
        {
        case EXTENDED:
            processExt();
            break;
        case STANDARD:
            processStd();
            break;
        case SPECIAL:
            processSpecial();
            break;
        }
    }
}

DLTable::StateMachine *DLTable::StateMachine::createSM(DebugLineHeader *dlh, char *buf, DLTable *dlTable)
{
    StateMachine *sm = new StateMachine(buf);
    sm->is_stmt = dlh->default_is_stmt;
    sm->min_instruction_length = dlh->min_instruction_length;
    sm->line_base = dlh->line_base;
    sm->line_range = dlh->line_range;
    sm->opcode_base = dlh->opcode_base;
    sm->line = 1;
    sm->file = 1;
    sm->buf = buf;
    // sm->bsize = dlh->length + 4 - (buf - (char *)dlh);
    sm->bsize = dlTable->bsize - dlTable->bp;
    sm->dlTable = dlTable;
    return sm;
}

DebugInfo *DebugInfo::createDebugInfo(char *debug_info, char *debug_abbrev, char *debug_line, char *debug_str)
{
    DebugInfo *DI = new DebugInfo();
    DI->strTable = debug_str;
    DI->abbrevTable = AbbrevTable::createAbbrevTable(debug_abbrev, 0);
    DI->diTable = DITable::createDITable(debug_info, DI->abbrevTable, DI);
    return DI;
}

DebugInfo *DebugInfo::create(std::string file)
{

    DebugInfo *DI = new DebugInfo();
    DI->init(file);
    return DI;
}

void DebugInfo::readELFHeader()
{

    uint64_t data = 0;

    ifs.seekg(4);
    ifs.read((char *)&data, 1);
    if (data == 1)
    {
        elfHeader.bitType = BIT32;
    }
    else
    {
        elfHeader.bitType = BIT64;
    }
    //大端 小端
    ifs.seekg(5);
    ifs.read((char *)&data, 1);

    if (data == 1)
        elfHeader.endian = LITTLE;
    else
        elfHeader.endian = BIG;

    //架构
    ifs.seekg(0x12);
    ifs.read((char *)&data, 2);
    switch (data)
    {
    case 0x03:
        elfHeader.machine = X32;
        break;
    case 0x28:
        elfHeader.machine = ARM32;
        break;
    case 0x32:
        elfHeader.machine = X64;
        break;
    case 0xB7:
        elfHeader.machine = ARM64;
        break;
    default:
        elfHeader.machine = UNKNOWN;
    }

    //program header offset
    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x1C);
        ifs.read((char *)&data, 4);
    }
    else
    {
        ifs.seekg(0x20);
        ifs.read((char *)&data, 8);
    }
    elfHeader.phoff = data;

    //section header offset
    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x20);
        ifs.read((char *)&data, 4);
    }
    else
    {
        ifs.seekg(0x28);
        ifs.read((char *)&data, 8);
    }
    elfHeader.shoff = data;

    //header size
    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x28);
        ifs.read((char *)&data, 2);
    }
    else
    {
        ifs.seekg(0x34);
        ifs.read((char *)&data, 2);
    }
    elfHeader.size = data;

    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x2A);
        ifs.read((char *)&data, 2);
    }
    else
    {
        ifs.seekg(0x36);
        ifs.read((char *)&data, 2);
    }
    elfHeader.phsize = data;

    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x2C);
        ifs.read((char *)&data, 2);
    }
    else
    {
        ifs.seekg(0x38);
        ifs.read((char *)&data, 2);
    }
    elfHeader.phnum = data;

    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x2E);
        ifs.read((char *)&data, 2);
    }
    else
    {
        ifs.seekg(0x3A);
        ifs.read((char *)&data, 2);
    }
    elfHeader.shsize = data;

    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x30);
        ifs.read((char *)&data, 2);
    }
    else
    {
        ifs.seekg(0x3C);
        ifs.read((char *)&data, 2);
    }
    elfHeader.shnum = data;

    if (elfHeader.bitType == BIT32)
    {
        ifs.seekg(0x32);
        ifs.read((char *)&data, 2);
    }
    else
    {
        ifs.seekg(0x3E);
        ifs.read((char *)&data, 2);
    }
    elfHeader.shstrndx = data;
}

void DebugInfo::init(std::string file)
{

    ifs.open(file);
    if (ifs.bad())
    {
        fprintf(stderr, "fail to open file : %s", file.c_str());
        exit(101);
    }

    //    Elf64_Ehdr elfHeader;
    //    ifs.readsome((char *) (&elfHeader), sizeof(Elf64_Ehdr));
    //    printf_d(2,"ELF file :%s \n", elfHeader.e_ident);

    readELFHeader();
    //section string table index
    char *shstrtab;

    SectionHeader sstab = readSectionHeader(elfHeader.shoff + elfHeader.shsize * elfHeader.shstrndx);
    //    ifs.seekg(elfHeader.e_shoff + elfHeader.e_shentsize * elfHeader.e_shstrndx);
    //    ifs.readsome((char *) (&sstab), sizeof(Elf64_Shdr));

    shstrtab = readShData(sstab);
    printf_d(2, "section name index: %s\n", (shstrtab + sstab.sh_name));

    createTabs(shstrtab);

    ifs.close();
    delete shstrtab;

    if (!diTable || !abbrevTable || !dlTable || !strTable)
    {

        fprintf(stderr, "no debugging symbols found, compile it with -g.");
    }
}

char *DebugInfo::readShData(SectionHeader shdr)
{

    char *sh_data = new char[shdr.sh_size];
    ifs.seekg(shdr.sh_offset);
    ifs.read(sh_data, shdr.sh_size);
    return sh_data;
}

SectionHeader DebugInfo::readSectionHeader(uint32_t offset)
{
    SectionHeader sh;
    char data[8];

    //name
    ifs.seekg(offset);
    ifs.read((char *)&data, 4);
    sh.sh_name = *(uint32_t *)data;

    ifs.seekg(offset + 4);
    ifs.read((char *)&data, 4);
    sh.sh_type = *(uint32_t *)data;

    //offset
    if (elfHeader.bitType == BIT32)
    {

        ifs.seekg(offset + 0x10);
        ifs.read((char *)&data, 4);
        sh.sh_offset = *(uint32_t *)data;
    }
    else
    {
        ifs.seekg(offset + 0x18);
        ifs.read((char *)&data, 8);
        sh.sh_offset = *(uint64_t *)data;
    }

    //size
    if (elfHeader.bitType == BIT32)
    {

        ifs.seekg(offset + 0x14);
        ifs.read((char *)&data, 4);
        sh.sh_size = *(uint32_t *)data;
    }
    else
    {
        ifs.seekg(offset + 0x20);
        ifs.read((char *)&data, 8);
        sh.sh_size = *(uint64_t *)data;
    }

    return sh;
}

void DebugInfo::createTabs(char *shstrtab)
{

    SectionHeader shdr;
    int sh_num = elfHeader.shnum;
    printf_d(2, "get debug info ...\n");
    char *di = 0;
    for (int i = 0; i < sh_num; i++)
    {
        //        ifs.seekg(elfHeader.shoff + i * elfHeader.shsize);
        //        ifs.read((char *) (&shdr), sizeof(Elf64_Shdr));
        shdr = readSectionHeader(elfHeader.shoff + i * elfHeader.shsize);
        printf_d(2, "\tsection name:%s\n", shstrtab + (shdr.sh_name));
        if (!strcmp(".debug_line", shstrtab + (shdr.sh_name)))
        {
            dlTable = DLTable::createDLTable(readShData(shdr), this);
        }
        else if (!strcmp(".debug_info", shstrtab + (shdr.sh_name)))
        {
            di = readShData(shdr);
        }
        else if (!strcmp(".debug_str", shstrtab + (shdr.sh_name)))
        {
            strTable = readShData(shdr);
        }
        else if (!strcmp(".debug_abbrev", shstrtab + (shdr.sh_name)))
        {
            abbrevTable = AbbrevTable::createAbbrevTable(readShData(shdr), shdr.sh_size);
        }
    }

    diTable = DITable::createDITable(di, abbrevTable, this);
    dlTable->printLineNumber();
}

ArrayType *DebugInfo::createArrayType(DIEntry *die)
{

    uint32_t refty = die->getATValue(DW_AT_type);
    Type *bTy = mtypes.find(refty) != mtypes.end() ? mtypes.find(refty)->second : nullptr;
    vector<DIEntry *> subs = die->getChildren();
    vector<uint32_t> subranges;
    for (unsigned i = 0; i < subs.size(); i++)
    {

        subranges.push_back(subs[i]->getATValue(DW_AT_count));
    }
    return new ArrayType(bTy, subranges);
}

StructType *DebugInfo::createStructType(StructType *sTy, DIEntry *die)
{
    vector<DIEntry *> subs = die->getChildren();

    for (unsigned i = 0; i < subs.size(); i++)
    {
        sTy->addVar(genVar(subs[i], DW_TAG_member));
    }
    return sTy;
}

// construct cu
void DebugInfo::genCUList(std::vector<CompilationUnit *> &clist)
{

    for (uint i = 0, e = abbrevTable->getCUNum(); i != e; ++i)
    {
        cu_index = i;
        clist.push_back(genCU());
    }
}

CompilationUnit *DebugInfo::genCU()
{
    printf_d(2,"\n======================DebugInfo::genCU======================\n");
    CompilationUnit *cu = CompilationUnit::createCU();

    vector<DIEntry *> dList = diTable->getDIEntries(cu_index);
    map<uint32_t, DIEntry *> refTypes = diTable->getRefTypes(cu_index);
    vector<TagEntry *> tList = abbrevTable->getEntries(cu_index);
    vector<Type *> tys;

    DIEntry *die;
    string name;
    uint8_t size;

    Type *ty;
    for (auto it = refTypes.begin(); it != refTypes.end(); it++)
    {
        die = it->second;
        size = die->getATValue(DW_AT_byte_size);
        name = die->getATStrValue(DW_AT_name);
        uint8_t tcode = die->getATValue(DW_AT_encoding);
        TAG tag = tList[die->getCode()]->getTAG();
        //        等回填
        //        if(tList[die->getCode()]->getTAG() == DW_TAG_pointer_type){//ptr type
        //            uint32_t  refty =die->getATValue(DW_AT_type) ;
        //            ty = new Type(size,name,0);
        //        }else{
        //            uint8_t  tcode = die->getATValue(DW_AT_encoding);
        //            ty = new Type(size,name,tcode);
        //        }
        if (tag == DW_TAG_base_type)
        {
            ty = new BasicType(size, tcode, name);
            mtypes.insert(pair<uint32_t, Type *>(it->first, ty));
            tys.push_back(ty);
        }
        else if (tag == DW_TAG_pointer_type)
        {

            ty = new PtrType(diTable->address_size, nullptr);
            mtypes.insert(pair<uint32_t, Type *>(it->first, ty));
            tys.push_back(ty);
        }
        else if (tag == DW_TAG_structure_type)
        {
            ty = new StructType();
            mtypes.insert(pair<uint32_t, Type *>(it->first, ty));
            tys.push_back(ty);
        }
        else if (tag == DW_TAG_const_type)
        {
            ty = new ConstType(nullptr);
            mtypes.insert(pair<uint32_t, Type *>(it->first, ty));
            tys.push_back(ty);
        }
        else if (tag == DW_TAG_typedef)
        {
            // uint32_t refty = die->getATValue(DW_AT_type);
            TypeDefType *TDT = new TypeDefType(nullptr);
            mtypes.insert(pair<uint32_t, Type *>(it->first, TDT));
            tys.push_back(TDT);
        }
    }

    size_t i = 0;
    for (auto it = refTypes.begin(); it != refTypes.end(); it++)
    {
        die = it->second;
        TAG tag = tList[die->getCode()]->getTAG();
        if (tag == DW_TAG_pointer_type)
        {
            uint32_t refty = die->getATValue(DW_AT_type);
            if (mtypes.find(refty) != mtypes.end())
                ((PtrType *)(mtypes.find(it->first)->second))->setType(mtypes.find(refty)->second);
        }
        else if (tag == DW_TAG_array_type)
        {
            ty = createArrayType(die);
            mtypes.insert(pair<uint32_t, Type *>(it->first, ty));
            tys.push_back(ty);
        }
        else if (tag == DW_TAG_typedef)
        {
            uint32_t refty = die->getATValue(DW_AT_type);
            TypeDefType *TDT = (TypeDefType *)mtypes.find(it->first)->second;
            if (mtypes.find(refty) != mtypes.end())
                TDT->setType(mtypes.find(refty)->second);
        }
        else if (tag == DW_TAG_structure_type)
        {
            ty = createStructType((StructType *)mtypes.find(it->first)->second, die);
        }
        else if (tag == DW_TAG_const_type)
        {
            uint32_t refty = die->getATValue(DW_AT_type);
            Type *rty = mtypes.find(refty) == mtypes.end() ? nullptr : mtypes.find(refty)->second;

            ((ConstType *)(mtypes.find(it->first)->second))->setType(rty);
        }

        i++;
    }

    for (index = 0; index < dList.size(); index++)
    {
        die = dList[index];
        TAG tag = tList[die->getCode()]->getTAG();
        if (tag == DW_TAG_subprogram)
        {

            cu->addFunction(genFunction());
        }
        else if (tag == DW_TAG_variable)
        {

            cu->addVar(genVar(die, tag));
        }
    }
    cu->addTypes(tys);
    return cu;
}

Function *DebugInfo::genFunction()
{

    vector<DIEntry *> dList = diTable->getDIEntries(cu_index);
    map<uint32_t, DIEntry *> refTypes = diTable->getRefTypes(cu_index);
    vector<TagEntry *> tList = abbrevTable->getEntries(cu_index);
    DIEntry *fdie = dList[index];
    DIEntry *die;
    string name;
    uint32_t line;
    string file;

    //Function info
    Type *rTy = nullptr;
    if (!fdie->getATValue(DW_AT_type))
        rTy = new VoidType();
    else
        rTy = mtypes.find(fdie->getATValue(DW_AT_type)) != mtypes.end() ? mtypes.find(fdie->getATValue(DW_AT_type))->second : nullptr;

    name = fdie->getATStrValue(DW_AT_name);
    file = dlTable->getFileName(fdie->getATValue(DW_AT_decl_file));
    line = fdie->getATValue(DW_AT_decl_line);
    Range r;
    r.start = fdie->getATValue(DW_AT_low_pc);
    r.end = r.start + fdie->getATValue(DW_AT_high_pc);
    Function *fun = new Function(rTy, name, file, line, r);

    std::vector<DIEntry *> chDies = fdie->getChildren();
    //parms ,variables info
    for (int i = 0; i < chDies.size(); i++)
    {
        die = chDies[i];

        if (die->getCode() == 0)
            break;
        TAG tag = tList[die->getCode()]->getTAG();
        if (tag == DW_TAG_formal_parameter || tag == DW_TAG_variable)
        {

            fun->addVar(genVar(die, tag));
        }
    }

    //fill line number tab

    fun->setLNT(dlTable->extractLNT(fun->getRange()));

    return fun;
}

Variable *DebugInfo::genVar(DIEntry *die, TAG tag)
{

    string name = die->getATStrValue(DW_AT_name);
    uint32_t line = die->getATValue(DW_AT_decl_line);
    uint64_t location = die->getATValue(DW_AT_location);
    string file = dlTable->getFileName(die->getATValue(DW_AT_decl_file));
    Type *ty = mtypes.find(die->getATValue(DW_AT_type)) == mtypes.end() ? nullptr : mtypes.find(die->getATValue(DW_AT_type))->second;

    Scope scope = GLOBAL;

    if (die->getATValue(DW_AT_external))
        scope = GLOBAL;
    else if (tag == DW_TAG_formal_parameter)
        scope = FORMAL;
    else if (tag == DW_TAG_variable)
        scope = LOCAL;

    Variable *var = new Variable(scope, name, ty, file, line, location);
    return var;
}
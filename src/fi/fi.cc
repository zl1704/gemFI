#include <ctime>
#include "fi/fi.hh"
#include "fi/util.hh"
#include "fi/fi_sys.hh"
#include "debug/FI.hh"
#include "debug/DPUFI.hh"
#include "debug/REGFI.hh"
#include "debug/CUFI.hh"
#include "debug/VARFI.hh"
#include "debug/MEMFI.hh"
#include "debug/MPUFI.hh"
#include "debug/PFUFI.hh"
#include "debug/CACHEFI.hh"
using namespace std;
using namespace util;
FaultInject *FaultInject::create(IniReader *config, FISystem *fiSystem)
{
    FaultInject *fi = nullptr;
    string fipos = config->getValue("GLOBAL", "fipos");
    if (fipos == "REG")
        fi = new REGFI(fiSystem, config);
    else if (fipos == "CU")
        fi = new CUFI(fiSystem, config);
    else if (fipos == "VAR")
        fi = new VarFI(fiSystem, config);
    else if (fipos == "ALU" || fipos == "DPU")
        fi = new DpuFI(fiSystem, config);
    else if (fipos == "MEM")
        fi = new MemFI(fiSystem, config);
    else if (fipos == "MPU")
        fi = new MpuFI(fiSystem, config);
    else if (fipos == "PFU")
        fi = new PFUFI(fiSystem, config);
    else if (fipos == "CACHE")
        fi = new CacheFI(fiSystem, config);
    else
        fi = new FaultInject(fiSystem, config);

    return fi;
}

FaultInject::FaultInject(FISystem *_fiSystem, IniReader *config) : fiSystem(_fiSystem)
{
    random = fiType(config->getValue("GLOBAL", "fitype")) == RANDOM ? true : false;
    fcount = strToNum<uint8_t>(config->getValue("GLOBAL", "FN"));
    if (!fcount)
        fcount = 1;
    ranPickFun();
    if (!random)
        readFLData(config);
    finish = false;
};

void FaultInject::readFLData(IniReader *config)
{
    file = config->getValue("FL", "file");
    string strval = config->getValue("FL", "line");
    line = strval == "" ? -1 : strToNum<int32_t>(strval);
    if (line < 0)
        random = true;
    Function *tfunction = fiSystem->getFunction(file, config->getValue("FL", "fun"));
    if (!tfunction)
        tfunction = fiSystem->getFunction("", config->getValue("FL", "fun"));
    // else
    //     cprintf("WARN: can't not find function :%s -> %s,  uses random function : %s\n",file, config->getValue("FL", "fun"), function->getName());
    function = tfunction;
    if (!function)
    {
        function = fiSystem->findFunByLine(line);
    }
}
FITYPE FaultInject::fiType(string val)
{
    if (val == "F")
        return FIXED;
    else
        return RANDOM;
}
void FaultInject::ranPickFun()
{
    vector<Function *> funs = fiSystem->mcu->getFuns();
    uint64_t index = genRan(0, funs.size() - 1);
    assert(index < funs.size());
    function = funs[index];
}

void FaultInject::dump()
{
    DPRINTF(FI, "\n==========FI DUMP %s===========\n", name());
    if ("FaultInject" == name())
    {
        return;
    }
    if (function)
        function->print();
}

uint64_t FaultInject::genRan(uint64_t from, uint64_t to)
{
    srand((uint32_t)time(0));
    return rand() % (to - from + 1) + from;
}
//递归情况判断
bool FaultInject::ranTrigger(uint64_t from, uint64_t to, uint64_t cur, uint32_t rdepth)
{
    if (rdepth == 1)
        return cur >= genRan(from, to);
    else
        return (cur >= genRan(from, to)) && (cur >= genRan(from, to));
}
uint64_t FaultInject::flip(uint64_t data, uint8_t pos)
{
    data ^= 1 << pos;
    return data;
}
// fc： 翻转位数

uint64_t FaultInject::ranFlip(uint64_t data, uint8_t size, uint8_t fc)
{
    return ranFlip(data, 0, size - 1, fc);
}
uint64_t FaultInject::ranFlip(uint64_t data, uint8_t from, uint8_t to, uint8_t fc)
{
    uint8_t fset = 0;
    uint8_t fd = 0;
    while (fc)
    {
        fd = genRan(from, to);
        if (bits(fset, fd))
            continue;
        insertBits(fset, fd, 1);
        fc--;
        data = flip(data, fd);
    }

    return data;
}

bool FaultInject::checkExec()
{
    if (finish)
        return false;
    Frame *frame = fiSystem->getFrame();
    if (!frame)
        return false;
    Function *exe_fun = frame->getFun();
    if (exe_fun == function)
    {
        if (random || line == -1)
        {
            Range r = exe_fun->getRange();
            uint32_t rdepth = fiSystem->getRecurDepth();
            // cprintf("start: %d, end %d, cur: %d \n",r.start,r.end,fiSystem->pc.instAddr());
            return ranTrigger(r.start, r.end, fiSystem->pc.instAddr() - 4, rdepth);
        }
        else
            return line == function->findLine(fiSystem->pc.instAddr());
    }
    return false;
}

VarFI::VarFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
    string var_name = config->getValue("VAR", "name");
    if (function)
        var = function->findVar(var_name);
    if (!var)
        var = fiSystem->getVar("", var_name);
}

void VarFI::execute()
{

    if (!var || !checkExec())
        return;
    Frame *frame = fiSystem->getFrame();
    DPRINTF(VARFI, "REGFI INFO: , name = %s \n", var->getName());
    var->print();
    if (var->getScope() == GLOBAL)
    {
        //全局变量
        fiSystem->writeMem(var->getLoc(), 100);
    }
    else
    {
        //参数，局部变量
        RegVal sp = frame->getSpRegVal();
        fiSystem->writeMem(sp + var->getLoc(), 100);
    }

    finish = true;
}

REGFI::REGFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
}

void REGFI::execute()
{

    if (!checkExec())
        return;

    IntRegIndex ri = (IntRegIndex)genRan(0, 7);
    uint64_t rVal = fiSystem->readReg(ri);
    uint64_t fVal = ranFlip(rVal, 32, fcount);

    DPRINTF(REGFI, "REGFI INFO: ,REG : %d , Before Val: 0x%x , After Val: 0x%x \n ", ri, rVal, fVal);

    fiSystem->writeReg(ri, fVal);

    finish = true;
}

MemFI::MemFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
    fiSystem->memRecords.resize(-1);
}

void MemFI::execute()
{
    if (!checkExec())
        return;
    uint8_t ran = genRan(0, fiSystem->memRecords.size() - 1);
    // fiSystem->memCache.dump();
    // fiSystem->memRecords.dump();
    std::pair<Addr, uint32_t> datap = fiSystem->memRecords.get(ran);
    uint32_t fVal = ranFlip(datap.second, 32, fcount);

    fiSystem->writeMem(datap.first, fVal);
    DPRINTF(MEMFI, "MEMFI INFO: Mem Addr : 0x%x , Before Data : 0x%x , After Data: 0x%x\n", datap.first, datap.second, fVal);

    fiSystem->memRecords.dump();

    finish = true;
}

CUFI::CUFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
    printFlag = false;
}

void CUFI::preExecute()
{
    if (!checkExec())
        return;
    AtomicSimpleCPU *cpu = fiSystem->getCPU();
    DPRINTF(CUFI, "CUFI INFO : Before execute instruction: %x\n", cpu->inst);
    cpu->inst = ranFlip(cpu->inst, 32, fcount);
    DPRINTF(CUFI, "CUFI INFO : After execute instruction: %x\n", cpu->inst);
    finish = true;
    printFlag = true;
}

void CUFI::execute()
{
    if (printFlag)
    {
        DPRINTF(CUFI, "CUFI INFO : After FI inst is  %s\n", fiSystem->getCPU()->curStaticInst->getName());
        printFlag = false;
    }
}

DpuFI::DpuFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
    isRd = false;
    printFlag = false;
    init();
}

void DpuFI::init()
{

    aluops.push_back(0b00000); //AND
    aluops.push_back(0b00010); //EOR
    aluops.push_back(0b00100); //SUB
    aluops.push_back(0b00110); //RSB
    aluops.push_back(0b01000); //ADD
    aluops.push_back(0b01010); //ADC
    aluops.push_back(0b01100); //SBC
    aluops.push_back(0b01110); //RSC
    aluops.push_back(0b10000); //SWP
    aluops.push_back(0b10001); //TST
    aluops.push_back(0b10011); //TEQ
    aluops.push_back(0b10101); //CMP
    aluops.push_back(0b10111); //CMN
    aluops.push_back(0b11000); //ORR
    aluops.push_back(0b11010); //MOV
    aluops.push_back(0b11100); //BIC
    aluops.push_back(0b11110); //NOT
}

std::string opName(uint32_t op)
{

    switch (op)
    {
    case 0b00000:
        return "AND";

    case 0b00010:
        return "EOR";

    case 0b00100:
        return "RSB";

    case 0b01000:
        return "ADD";

    case 0b01010:
        return "ADC";

    case 0b01100:
        return "SBC";

    case 0b01110:
        return "RSC";

    case 0b10000:
        return "SWP";

    case 0b10001:
        return "TST";

    case 0b10011:
        return "TEQ";

    case 0b10101:
        return "CMP";

    case 0b10111:
        return "CMN";

    case 0b11000:
        return "ORR";

    case 0b11010:
        return "MOV";

    case 0b11100:
        return "BIC";

    case 0b11110:
        return "NOT";
    default:
        return "UNKOWN";
    }
}

void DpuFI::fiOpcode()
{
    uint32_t old_op = bits(inst, 24, 20);

    DPRINTF(DPUFI, "DpuFI fiOpcode INFO : Before execute instruction: %x, op : %s\n", inst, opName(old_op).c_str());
    uint8_t opi = genRan(0, aluops.size() - 1);
    uint32_t new_op = aluops[opi];
    while (new_op == old_op)
    {

        opi = genRan(0, aluops.size() - 1);
        new_op = aluops[opi];
    }

    inst = insertBits(inst, 24, 20, new_op);
    DPRINTF(DPUFI, "DpuFI fiOpcode INFO : After execute instruction: %x, op : %s\n", inst, opName(new_op).c_str());
}
//操作数1
void DpuFI::fiRn()
{
    DPRINTF(DPUFI, "DpuFI fiRn INFO : Before execute instruction: %x\n", inst);
    // uint8_t nrn = genRan(0, 31);
    uint8_t rn = bits(inst, 16, 19);
    uint64_t rnv = fiSystem->readReg((IntRegIndex)rn);
    // inst = flip(inst,nrn);
    rnv = ranFlip(rnv, 32, fcount);
    fiSystem->writeReg((IntRegIndex)rn, rnv);
    DPRINTF(DPUFI, "DpuFI fiRn INFO : After execute instruction: %x\n", inst);
}
//目的寄存器
void DpuFI::fiRd()
{
    isRd = true;
}
void DpuFI::fiOp2()
{
    DPRINTF(DPUFI, "DpuFI fiOp2 INFO : Before execute instruction: %x\n", inst);
    // uint8_t nop2 = genRan(7, 11);
    inst = ranFlip(inst, 7, 11, fcount);
    DPRINTF(DPUFI, "DpuFI fiOp2 INFO : After execute instruction: %x\n", inst);
}
//RR 第二个操作数
void DpuFI::fiRROp2()
{
    /**
     *  有3个位置可以选择
     *  1. rm  : 0-3 
     *  2. op2 : 5-6
     *  3. imm5: 7-11
     */

    uint8_t ran = genRan(1, 3);
    if (ran == 1)
    {
        uint8_t Rm = bits(inst, 3, 0);
        DPRINTF(DPUFI, "DpuFI RR-Inst on Rm : R%d \n", Rm);

        uint32_t rVal = fiSystem->readReg((IntRegIndex)Rm);
        DPRINTF(DPUFI, "DpuFI RR-Inst INFO : Before execute R%d  : %x \n", Rm, rVal);

        uint32_t new_val = ranFlip(rVal, 32, fcount);
        DPRINTF(DPUFI, "DpuFI RR-Inst INFO : After execute R%d : %x \n", Rm, new_val);
        fiSystem->writeReg((IntRegIndex)Rm, new_val);
    }
    else if (ran == 2)
    {
        DPRINTF(DPUFI, "DpuFI RR-Inst Change Op2 INFO : Before execute : %x\n", bits(inst, 6, 5));
        inst = ranFlip(inst, 5, 6, 1);
        DPRINTF(DPUFI, "DpuFI RR-Inst Change Op2 INFO : After execute : %x\n", bits(inst, 6, 5));
    }
    else
    {

        DPRINTF(DPUFI, "DpuFI RR-Inst Change Imm INFO : Before execute : %x\n", bits(inst, 11, 7));
        inst = ranFlip(inst, 7, 11, 1);
        DPRINTF(DPUFI, "DpuFI RR-Inst Change Imm INFO : After execute : %x\n", bits(inst, 11, 7));
    }
}
//RRS 第二个操作数
void DpuFI::fiRRSOp2()
{
    /**
     *  有3个位置可以选择
     *  1. rm  : 0-3 
     *  2. op2 : 5-6
     *  3. Rs  : 8-11
     */

    uint8_t ran = genRan(1, 3);
    if (ran == 1)
    {
        uint8_t Rm = bits(inst, 3, 0);
        DPRINTF(DPUFI, "DpuFI RR-Inst on Rm : R%d \n", Rm);

        uint32_t rVal = fiSystem->readReg((IntRegIndex)Rm);
        DPRINTF(DPUFI, "DpuFI RR-Inst INFO : Before execute R%d  : %x \n", Rm, rVal);

        uint32_t new_val = ranFlip(rVal, 32, fcount);
        DPRINTF(DPUFI, "DpuFI RR-Inst INFO : After execute R%d : %x \n", Rm, new_val);
        fiSystem->writeReg((IntRegIndex)Rm, new_val);
    }
    else if (ran == 2)
    {
        DPRINTF(DPUFI, "DpuFI RRS-Inst Change Op2 INFO : Before execute : %x\n", bits(inst, 6, 5));
        inst = ranFlip(inst, 5, 6);
        DPRINTF(DPUFI, "DpuFI RRS-Inst Change Op2 INFO : After execute : %x\n", bits(inst, 6, 5));
    }
    else
    {

        uint8_t Rs = bits(inst, 3, 0);
        DPRINTF(DPUFI, "DpuFI RRS-Inst on Rs : R%d \n", Rs);

        uint32_t rVal = fiSystem->readReg((IntRegIndex)Rs);
        DPRINTF(DPUFI, "DpuFI RRS-Inst INFO : Before execute R%d  : %x \n", Rs, rVal);

        uint32_t new_val = ranFlip(rVal, 32, fcount);
        DPRINTF(DPUFI, "DpuFI RRS-Inst INFO : After execute R%d : %x \n", Rs, new_val);
        fiSystem->writeReg((IntRegIndex)Rs, new_val);
    }
}
//RI 第二个操作数
void DpuFI::fiRIOp2()
{
    //Imm: 0-11
    DPRINTF(DPUFI, "DpuFI RI-Inst Change Imm(0-11) INFO : Before execute : %x\n", bits(inst, 11, 0));
    inst = ranFlip(inst, 0, 11, fcount);
    DPRINTF(DPUFI, "DpuFI RI-Inst Change Imm(0-11) INFO : After execute : %x\n", bits(inst, 11, 0));
}

//RR类型 指令
void DpuFI::processRRInst()
{
    uint64_t fip = genRan(1, 3);
    switch (fip)
    {
    case 1:
        fiOpcode();
        break;
    case 2:
        fiRd();
        break;
    case 3:
        fiRROp2();
        break;
    default:
        break;
    }
}
//RI类型 指令
void DpuFI::processRIInst()
{
    uint64_t fip = genRan(1, 3);
    switch (fip)
    {
    case 1:
        fiOpcode();
        break;
    case 2:
        fiRd();
        break;
    case 3:
        fiRIOp2();
        break;
    default:
        break;
    }
}
//RR-Shift类型 指令
void DpuFI::processRRSInst()
{
    uint64_t fip = genRan(1, 3);
    switch (fip)
    {
    case 1:
        fiOpcode();
        break;
    case 2:
        fiRd();
        break;
    case 3:
        fiRRSOp2();
        break;
    default:
        break;
    }
}

void DpuFI::preExecute()
{
    AtomicSimpleCPU *cpu = fiSystem->getCPU();
    inst = cpu->inst;
    if (bits(inst, 27, 26) != 0 || !checkExec())
        return;

    if (bits(inst, 25, 25))
    {
        processRIInst();
    }
    else
    {

        if (bits(inst, 4, 4))
            processRRSInst();
        else
            processRRInst();
    }

    // uint64_t fip = genRan(1, 4);
    // switch (fip)
    // {
    // case FIOC:
    //     fiOpcode();
    //     break;
    // case FIRN:
    //     fiRn();
    //     break;
    // case FIRD:
    //     fiRd();
    //     break;
    // case FIOP2:
    //     fiOp2();
    //     break;
    // default:
    //     break;
    // }
    cpu->inst = inst;
    printFlag = true;
    finish = true;
}
void DpuFI::execute()
{

    // if (printFlag)
    // {
    //     DPRINTF(DPUFI, "DpuFI  INFO :After FI inst is  %s\n", fiSystem->getCPU()->curStaticInst->getName());
    //     printFlag = false;
    // }
}
void DpuFI::postExecute()
{
    if (isRd)
    {
        // uint8_t nrd = genRan(0, 31);
        uint8_t rd = bits(inst, 12, 15);
        uint64_t rdv = fiSystem->readReg((IntRegIndex)rd);
        DPRINTF(DPUFI, "DpuFI fiRd INFO : Before execute R%d  : %x \n", rd, rdv);

        // inst = flip(inst,nrn);
        rdv = ranFlip(rdv, 32, fcount);
        fiSystem->writeReg((IntRegIndex)rd, rdv);
        DPRINTF(DPUFI, "DpuFI fiRd INFO : After execute  R%d  : %x \n", rd, rdv);
        isRd = false;
    }
}

// ============MpuFI===================

MpuFI::MpuFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
}

void MpuFI::execute()
{
    if (!checkExec())
        return;
    doFIProcess();
    finish = true;
}

bool MpuFI::doFIProcess()
{
    uint32_t tsize = fiSystem->pTable->pTable.size();
    //随机选择一项
    uint32_t rdi = genRan(0, tsize - 1);
    auto bg = fiSystem->pTable->pTable.begin();
    // auto end = fiSystem->pTable->pTable.end();
    uint32_t index = 0;
    while (index != rdi)
    {
        bg++;
        index++;
    }

    Addr vaddr = bg->first;
    Addr paddr = bg->second.paddr;

    //随机选择一位, 低12位不考虑，对齐问题
    // uint8_t rdb = genRan(12, 31);
    Addr fval = ranFlip(paddr, 12, 31, fcount);

    DPRINTF(MPUFI, "MPUFI Info : Before Paddr: %x , After Paddr : %x \n", paddr, fval);
    fiSystem->pTable->unmap(vaddr, 0x1000);
    fiSystem->pTable->map(vaddr, fval, 0x1000);
    // printTlb();
    return true;
}

void MpuFI::printTlb()
{

    DPRINTF(MPUFI, "\n=================Page Table Dump===============\n");
    auto bg = fiSystem->pTable->pTable.begin();
    auto end = fiSystem->pTable->pTable.end();
    for (; bg != end; bg++)
    {

        DPRINTF(MPUFI, "Vaddr : %x , Paddr : %x \n", bg->first, bg->second.paddr);
    }
}

//==============Pre Fetch Unit FI==================
PFUFI::PFUFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{
    printFlag = false;
}

void PFUFI::preExecute()
{
    if (!checkExec())
        return;
    AtomicSimpleCPU *cpu = fiSystem->getCPU();
    DPRINTF(PFUFI, "PFUFI INFO : Before execute instruction: %x\n", cpu->inst);
    cpu->inst = ranFlip(cpu->inst, 32, fcount);
    DPRINTF(PFUFI, "PFUFI INFO : After execute instruction: %x\n", cpu->inst);
    finish = true;
    printFlag = true;
}

void PFUFI::execute()
{
    if (printFlag)
    {
        DPRINTF(PFUFI, "PFUFI INFO : After FI inst is  %s\n", fiSystem->getCPU()->curStaticInst->getName());
        printFlag = false;
    }
}

//==================Cache FI=================

CacheFI::CacheFI(FISystem *fiSystem, IniReader *config) : FaultInject(fiSystem, config)
{

    fiSystem->memRecords.resize(256);
}

void CacheFI::execute()
{

    if (!checkExec())
        return;
    uint32_t csize = fiSystem->memRecords.size();
    uint8_t ran = genRan(csize - 100, csize - 1);
    // fiSystem->memCache.dump();
    // fiSystem->memRecords.dump();
    std::pair<Addr, uint32_t> datap = fiSystem->memRecords.get(ran);
    if (!datap.second)
        datap.second = fiSystem->readMem(datap.first);
    uint32_t fVal = ranFlip(datap.second, 32, fcount);

    fiSystem->writeMem(datap.first, fVal);
    DPRINTF(CACHEFI, "CacheFI INFO: Mem Addr : 0x%x , Before Data : 0x%x , After Data: 0x%x\n", datap.first, datap.second, fVal);

    // fiSystem->memRecords.dump();

    finish = true;
}
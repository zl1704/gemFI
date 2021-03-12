#include <unistd.h>
#include "fi/fi_sys.hh"
#include "base/trace.hh"
#include "base/loader/symtab.hh"
#include "mem/page_table.hh"
#include "fi/util.hh"
#include "debug/FISYS.hh"
#include "debug/MEMFI.hh"


using namespace std;
using namespace util;
// void PCInfo::insert(std::string name,Addr pc){
//     map<string,Range>::iterator it = rmap.find(name);

//     Range r;

//     if(it != rmap.end()){
//         r = it->second;
//         rmap.erase(name);
//     }
//     if(pc < r.start)
//         r.start = pc;
//     if(pc > r.end)
//         r.end = pc;

//     rmap.insert(pair<string,Range>(name,r));

// }

// void PCInfo::dump(){

//     cprintf("=======PCInfo::dump=========\n");
//     for(map<string,Range>::iterator it = rmap.begin();it!=rmap.end();it++){
//         cprintf("fun name:%s, start: %d , end: %d\n",it->first,it->second.start,it->second.end);

//     }

// }

void LFUCache::resort()
{
    while (!queue.empty())
    {
        queue.pop();
    }

    for (auto it = emap.begin(); it != emap.end(); it++)
    {
        queue.push(it->second);
    }
}

void LFUCache::put(Addr addr, uint32_t data, bool is_write)
{
    map<Addr, Entry *>::iterator re = emap.find(addr);
    Entry *entry = nullptr;
    if (re == emap.end() && emap.size() == _capacity)
    {
        Entry *delete_entry = queue.top();
        queue.pop();
        emap.erase(delete_entry->addr);
        delete delete_entry;
    }
    if (re == emap.end())
    {
        entry = new Entry(addr, data, 0);
        queue.push(entry);
        emap.insert(pair<Addr, Entry *>(addr, entry));
    }
    else
    {
        entry = re->second;
    }

    entry->frequency++;
    DPRINTF(FISYS, "FISystem LFUCache info: %s entry  Addr = 0x%x,  Data = 0x%x ,Frequency = %d,Size = %d\n", is_write ? "Write" : "Read", addr, data, entry->frequency, emap.size());

    resort();
}

std::pair<Addr, uint32_t> LFUCache::get(uint16_t index)
{

    vector<Entry *> entries;

    uint16_t i = queue.size() - index - 1;
    while (i > 0 && !queue.empty())
    {
        i--;
        entries.push_back(queue.top());
        queue.pop();
    }
    Entry *cur = queue.top();

    DPRINTF(MEMFI, "LFUCache GET INFO:  Addr ：0x%x ,Data : 0x%x , Freq : %d \n", cur->addr, cur->data, cur->frequency);
    std::pair<Addr, uint32_t> res = pair<Addr, uint32_t>(cur->addr, cur->data);
    for (int i = 0; i < entries.size(); ++i)
    {
        queue.push(entries[i]);
    }
    return res;
}

void LFUCache::dump()
{
    cprintf("\n ==========LFUCache dump==============\n");
    vector<Entry *> entries;
    Entry *cur;
    while (!queue.empty())
    {
        entries.push_back((cur = queue.top()));
        queue.pop();
        DPRINTF(MEMFI, "LFUCache GET INFO:  Addr ：0x%x ,Data : 0x%x , Freq : %d \n", cur->addr, cur->data, cur->frequency);
    }
    for (int i = 0; i < entries.size(); ++i)
    {
        queue.push(entries[i]);
    }
}

// -----------------LRUCache -------------------
LRUCache::List::List()
{
    head = new Entry(0, 0, 0);
    last = head;
    head->next = last;
    last->prev = head;
}
void LRUCache::List::append(Entry *e)
{

    last->next = e;
    e->next = head;
    head->prev = e;
    e->prev = last;
    //update last ptr;
    last = e;
}
void LRUCache::List::remove(Entry *e)
{
    if (e == last)
        last = last->prev;

    e->prev->next = e->next;
    e->next->prev = e->prev;

    e->prev = nullptr;
    e->next = nullptr;
}

void LRUCache::List::moveToLast(Entry *e)
{
    remove(e);
    append(e);
}

void LRUCache::updateCache(Addr addr, uint32_t data)
{

    Entry *p;
    // 每一次miss 从内存中预读8*4B数据
    while (size() >= (_capacity - 8))
    {
        p = rList.head->next;
        emap.erase(p->addr);
        rList.remove(p);
        delete p;
    }
    Addr paddr = addr & (~31);
    bool need_insert = true;
    int i = 0;
    Entry *e;
    while (i < 7)
    {
        // uint32_t pd = fiSystem->readMem(paddr);
        //这里不能去读，递归了，暂时设为0
        // cprintf("FISystem LRUCache insert info:  entry  Addr = 0x%x,  Data = 0x%x ,Size = %d\n", paddr, data, emap.size());
        if (emap.find(paddr) != emap.end())
        {
            e = new Entry(paddr, 0, 0);
            emap.insert(pair<Addr, Entry *>(paddr, e));
            rList.append(e);
        }
        if (paddr == addr)
            need_insert = false;
        i++;
        paddr += 4;
    }
    if (need_insert)
    {
        e = new Entry(addr, data, 0);
        emap.insert(pair<Addr, Entry *>(paddr, e));
        rList.append(e);
    }
}

void LRUCache::put(Addr addr, uint32_t data, bool is_write)
{
    map<Addr, Entry *>::iterator re = emap.find(addr);
    Entry *entry = nullptr;
    // cprintf("FISystem LRUCache info: %s entry  Addr = 0x%x,  Data = 0x%x ,Size = %d\n", is_write ? "Write" : "Read", addr, data, emap.size());

    if (re == emap.end())
    {

        //考虑cache
        if (isCache())
        {
            // Entry *e = rList.head->next;
            // // cprintf("FISystem LRUCache delete info: %s entry  Addr = 0x%x,  Data = 0x%x ,Size = %d\n", is_write ? "Write" : "Read", e->addr, e->data, emap.size());

            // rList.remove(rList.head->next);
            // emap.erase(e->addr);
            // delete e;
            updateCache(addr, data);
        }
        else
        {
            entry = new Entry(addr, data, 0);
            emap.insert(pair<Addr, Entry *>(addr, entry));
            rList.append(entry);
        }
    }
    else
    {
        entry = re->second;
        if (is_write)
            entry->data = data;
        rList.moveToLast(entry);
    }
}
std::pair<Addr, uint32_t> LRUCache::get(uint16_t index)
{
    Entry *head = rList.head, *p = head->next;
    if (index > emap.size())
        return pair<Addr, uint32_t>(0, 0);
    uint16_t i = 0;
    while (p != head && i != index)
    {
        p = p->next;
        i++;
    }

    return pair<Addr, uint32_t>(p->addr, p->data);
}

void LRUCache::dump()
{

    cprintf("\n ==========Memory Usage Dump==============\n");
    cprintf("\t Table Size = %d\n", emap.size());
    Entry *head = rList.head, *p = head->next;
    while (p != head)
    {

        cprintf("\t Addr: %10x , Data: %10x \n", p->addr, p->data);
        p = p->next;
    }
}

//内存屏障，记录最近访存内容
void FISystem::memBarrier(Addr addr, uint8_t *data, uint32_t size, bool is_write)
{
    uint32_t c_data = 0;
    for (int i = 0; i < 4; i++)
    {
        c_data |= (data[i] << i * 8);
    }
    // memCache.put(addr, c_data, is_write);
    memRecords.put(addr, c_data, is_write);
}

void Frame::print()
{
    DPRINTF(FISYS, "\n===== frame info=== \n");
    DPRINTF(FISYS, "fun name: %s\n", function->getName().c_str());
    DPRINTF(FISYS, "sp val: %x\n", sp);
}

FISystem::FISystem(AtomicSimpleCPU *_cpu) : cpu(_cpu)
{

    // cprintf("The System is : %s\n",cpu->system->name().c_str());
    // std::cout << dynamic_cast<ArmSystem*>(cpu->system)<<endl;
    FIDebug = false;
    mcu = nullptr;
    frame = nullptr;
    memRecords.resize(-1);
    // string config_file = "configs/fi/fi.ini";
    
    config = new IniManager();
    initEnv();


    string dval = config->getValue("DEBUG", "compile");
    if (dval != "")
        util::debug = strToNum<uint32_t>(dval);
    else
        util::debug = 0;
    xc = cpu->threadInfo[cpu->curThread];
    thread = xc->thread;

    iwrite_req = std::make_shared<Request>();
    pTable = thread->getProcessPtr()->pTable;
    initFI();
    memRecords.setFISys(this);
}

/**
 *  找fi.ini 
 *  
 * 
 * 
 * */
bool FISystem::initEnv(){

    work_dir = getcwd(NULL,0);

    if (!config->readFromFile("fi.ini"))
    {
        cprintf("config file: %s/%s does not found\n", work_dir,"fi.ini");
        exit(101);
    }
    config_file = csprintf("%s/%s",work_dir,"fi.ini");

    return true;
}


bool FISystem::initFI()
{
    enable = config->getValue("GLOBAL", "enable") != "N";
    di = nullptr;
    FI = nullptr;
    mcu = nullptr;
    if (enable)
    {

        di = DebugInfo::create(config->getValue("GLOBAL", "program"));

        std::vector<CompilationUnit *> cus;
        //    CompilationUnit* cu = DI->genCU();
        di->genCUList(cus);
        for (CompilationUnit *cu : cus)
        {
            if (cu->findFunction("", "main"))
            {
                mcu = cu;
            }
        }

        // util::debug = true;
        // mcu->print();
        FI = FaultInject::create(config, this);
        FI->dump();
    }

    DPRINTF(FISYS, " FISystem is enable : %s\n", enable ? "yes" : "no");

    return true;
}

FISystem *FISystem::create(AtomicSimpleCPU *cpu)
{

    return new FISystem(cpu);
}
uint32_t FISystem::getRecurDepth()
{

    //fast way
    if (!frame || !frame->isActive())
        return 1;

    uint32_t depth = 1;

    stack<Frame *> ts;
    Frame *f;

    while (!fstack.empty() && (f = fstack.top())->getFun() == frame->getFun())
    {

        depth++;
        ts.push(f);
        fstack.pop();
    }

    while (!ts.empty())
    {

        fstack.push(ts.top());
        ts.pop();
    }

    return depth;
}

void FISystem::switchFrame()
{
    xc = cpu->threadInfo[cpu->curThread];
    thread = xc->thread;
    Addr cur_pc = pc.instAddr();
    // cprintf("Cur pc : 0x%x \n", cur_pc);
    Function *function = mcu->findFunByAddr(cur_pc);

    if (!function)
    {
        //跳到库函数中
        if (frame)
            frame->setActive(false);
        return;
    }

    if (!frame)
    {
        //第一个 main函数
        frame = new Frame(function, thread->readIntReg(INTREG_SP), cur_pc);
    }
    else
    {
        Range r = frame->getFun()->getRange();
        // frame->setActive(true);

        //在函数中间
        if (frame->isActive() && r.include(cur_pc, false) && r.start != cur_pc)
        {
            frame->setPC(cur_pc);
            return;
        }

        //递归情况
        if (function == frame->getFun())
        {
            /**
             * 1.递归情况
             * 2.入口指令是mircop
             */

            if (r.start == cur_pc && frame->getPC() != cur_pc)
            {
                frame->setActive(false);
                fstack.push(frame);
                frame = new Frame(function, thread->readIntReg(INTREG_SP), cur_pc);
            }
        }
        else
        {

            //进入新的函数
            //1.调用 2.返回
            if (cur_pc == function->getRange().start)
            {
                frame->setActive(false);
                fstack.push(frame);
                frame = new Frame(function, thread->readIntReg(INTREG_SP), cur_pc);
            }
            else
            {

                Frame *pframe = frame;

                frame = fstack.top();
                frame->setActive(true);
                fstack.pop();
                delete pframe;
            }
        }
    }
}

void FISystem::dumpFrame()
{

    cprintf("\n=================== Frame Dump ================\n");

    if (frame)
        cprintf(" frame function : %s \n", frame->getFun()->getName());

    Frame *f = nullptr;
    stack<Frame *> ts;

    while (!fstack.empty() && (f = fstack.top()))
    {
        cprintf(" frame function : %s \n", f->getFun()->getName());
        ts.push(f);
        fstack.pop();
    }

    while (!ts.empty())
    {

        fstack.push(ts.top());
        ts.pop();
    }
}

void FISystem::collectInfo()
{

    // StaticInstPtr &curInst = cpu->curStaticInst;
    // std::string sym_str;
    // Addr sym_addr = 0;
    // Addr cur_pc = pc.instAddr();
    // if(!FullSystem){
    //     debugSymbolTable->findNearestSymbol(cur_pc, sym_str, sym_addr);
    //     pcInfo.insert(sym_str,cur_pc);
    // }
}

//解码
void FISystem::preProcess()
{
    if (!enable)
        return;
    FI->preExecute();
}

void FISystem::process()
{
    //收集信息   故障注入
    if (!enable)
        return;
    collectInfo();
    switchFrame();
    // dumpFrame();
    // Addr cur_pc = pc.instAddr();
    FI->execute();

    //判断当前环境是否进行故障注入

    //进行故障注入类型
}

void FISystem::postProcess()
{

    if (!enable)
        return;
    FI->postExecute();
}

void FISystem::startTick()
{

    pc = cpu->threadInfo[cpu->curThread]->pcState();
}

Function *FISystem::getFunction(std::string file, std::string name)
{

    return mcu->findFunction(file, name);
}
Function *FISystem::findFunByLine(uint32_t line)
{
    return mcu->findFunByLine(line);
}
Variable *FISystem::getVar(std::string file, std::string name)
{
    return mcu->findVar(file, name);
}

void FISystem::writeMem(Addr addr, uint64_t data)
{
    const RequestPtr &req = cpu->data_write_req;
    req->setVirt(0, addr, 1, ArmISA::TLB::MustBeOne | Request::ACQUIRE, cpu->dataMasterId(),
                 thread->pcState().instAddr());
    //mem barrier
    uint8_t tdata[4];
    convertDataToArr(data, tdata);
    memBarrier(addr, tdata, 4, true);
    Fault fault = thread->dtb->translateAtomic(req, thread->getTC(),
                                               BaseTLB::Write);
    Packet pkt(req, Packet::makeWriteCmd(req));
    pkt.dataStatic(&data);
    cpu->sendPacket(cpu->dcachePort, &pkt);
}
uint64_t FISystem::readMem(Addr addr)
{
    uint64_t res = 0;
    const RequestPtr &req = cpu->data_write_req;
    req->setVirt(0, addr, 1, ArmISA::TLB::MustBeOne | Request::ACQUIRE, cpu->dataMasterId(),
                 thread->pcState().instAddr());

    Fault fault = thread->dtb->translateAtomic(req, thread->getTC(),
                                               BaseTLB::Write);
    Packet pkt(req, Packet::makeWriteCmd(req));
    pkt.dataStatic(&res);
    cpu->sendPacket(cpu->dcachePort, &pkt);
    //mem barrier
    uint8_t tdata[4];
    convertDataToArr(res, tdata);
    memBarrier(addr, (uint8_t *)tdata, 4, false);
    return res;
}

//读写指令
uint32_t FISystem::readInst(Addr addr)
{
    uint32_t inst;
    cpu->ifetch_req->taskId(cpu->taskId());
    cpu->setupFetchRequest(cpu->ifetch_req);
    Fault fault = thread->itb->translateAtomic(cpu->ifetch_req, thread->getTC(),
                                               BaseTLB::Execute);
    Packet ifetch_pkt = Packet(cpu->ifetch_req, MemCmd::ReadReq);
    ifetch_pkt.dataStatic(&inst);

    cpu->sendPacket(cpu->icachePort, &ifetch_pkt);
    return inst;

}
void FISystem::writeInst(Addr addr, uint32_t inst)
{
    // cpu->ifetch_req->taskId(cpu->taskId());
    const RequestPtr& req = iwrite_req;
    req->setVirt(0, addr, sizeof(MachInst), Request::ACQUIRE,
                cpu->instMasterId(), thread->pcState().instAddr());
    Fault fault = thread->itb->translateAtomic(req, thread->getTC(),
                                               BaseTLB::Execute);
    Packet iwrite_pkt = Packet(req, MemCmd::WriteReq);
    iwrite_pkt.dataStatic(&inst);
    cpu->sendPacket(cpu->icachePort, &iwrite_pkt);
}

void FISystem::writeReg(IntRegIndex reg, RegVal data)
{
    thread->setIntReg(reg, data);
}
RegVal FISystem::readReg(IntRegIndex reg)
{
    return thread->readIntReg(reg);
}

void FISystem::close()
{
    FI->Finish();
    DPRINTF(FISYS, "FISystem::close\n");
    // pcInfo.dump();
}
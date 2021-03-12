#ifndef __FI_SYS_HH_
#define __FI_SYS_HH_
#include <vector>
#include <map>
#include <string>
#include <queue>
#include "cpu/simple/atomic.hh"
#include "fi/fi.hh"
#include "fi/debug_info.hh"
#include "fi/ini_reader.hh"
#define UNSIGNEDMAX (1ULL << 63) - 1

// class Range
// {
// public:
//     Addr start;
//     Addr end;
// };

// class PCInfo
// {
// private:
//     std::map<std::string, Range> rmap;

// public:
//     void insert(std::string name, Addr pc);
//     void dump();
// };

/**
 * 优先淘汰最近很少被访问
 * 优先队列 + hashmap
 */
class LFUCache
{

private:
    struct Entry
    {
        Addr addr;
        uint32_t data;
        uint32_t frequency;
        Entry(Addr _addr, uint32_t _data, uint32_t _freq) : addr(_addr), data(_data), frequency(_freq){};
    };

    struct EntryCmp
    {
        bool operator()(Entry *&e1, Entry *&e2) { return e1->frequency > e2->frequency; }
    };

    std::priority_queue<Entry *, std::vector<Entry *>, EntryCmp> queue;
    std::map<Addr, Entry *> emap;
    uint32_t _capacity;
    void resort();

public:
    void put(Addr addr, uint32_t data, bool is_write);
    void resize(uint32_t capacity) { _capacity = capacity; }
    std::pair<Addr, uint32_t> get(uint16_t index);
    LFUCache(uint32_t capacity = 100) : _capacity(capacity) {}

    //是否当做cache使用
    void dump();
};

class LRUCache
{

private:
    struct Entry
    {
        Addr addr;
        uint32_t data;
        uint32_t frequency;

        Entry *next;
        Entry *prev;
        Entry(Addr _addr, uint32_t _data, uint32_t _freq) : addr(_addr), data(_data), frequency(_freq), next(nullptr), prev(nullptr){};
    };

    // struct EntryCmp
    // {
    //     bool operator()(Entry *&e1, Entry *&e2) { return e1->frequency > e2->frequency; }
    // };

    class List
    {
    public:
        Entry *head;
        Entry *last;
        List();
        void append(Entry *n);
        void remove(Entry *n);
        void moveToLast(Entry *n);
    };

    List rList;                   //record list
    std::map<Addr, Entry *> emap; //fast find
    FISystem *fiSystem;
    int64_t _capacity;
    void updateCache(Addr addr, uint32_t data);

public:
    void put(Addr addr, uint32_t data, bool is_write);
    std::pair<Addr, uint32_t> get(uint16_t index);
    void resize(int64_t capacity) { _capacity = capacity; }
    void setFISys(FISystem *fiSys) { fiSystem = fiSys; }
    LRUCache(int64_t capacity = 100) : _capacity(capacity) {}
    uint32_t size() { return emap.size(); }
    bool isCache() { return _capacity > 0; }

    void dump();
};

// runtime function frame
class Frame
{
public:
    Frame(Function *fun, RegVal _sp, Addr pc, bool _active = true) : function(fun), sp(_sp), _pc(pc), active(_active)
    {
        isAtEntry = true;
    }
    Function *getFun() { return function; }
    bool isActive() { return active; }
    void setActive(bool ac) { active = ac; }
    RegVal getSpRegVal() { return sp; }
    void setPC(Addr pc) { _pc = pc; }
    inline Addr getPC() { return _pc; }
    void print();
    //入口指令 是mircop的情况
    bool isAtEntry;

private:
    Function *function;
    RegVal sp;

    Addr _pc;
    bool active;
};

class EmulationPageTable;

class FISystem
{
    friend class FaultInject;
    friend class VarFI;
    friend class CUFI;
    friend class REGFI;
    friend class MemFI;
    friend class MpuFI;
    friend class PFUFI;

    friend class CacheFI;

public:
    bool FIDebug;
    static FISystem *create(AtomicSimpleCPU *cpu);

    void preProcess();
    void process();
    void postProcess();
    void close();
    void startTick();
    void switchFrame();

    Function *getFunction(std::string file, std::string name);
    Function *findFunByLine(uint32_t line);
    std::vector<Function*> getAllFunctions(){return mcu->getFuns();};
    Variable *getVar(std::string file, std::string name);
    Frame *getFrame() { return frame; }
    AtomicSimpleCPU *getCPU() { return cpu; }
    TheISA::PCState getPC() { return pc; }
    void writeMem(Addr addr, uint64_t data);
    uint64_t readMem(Addr addr);
    void writeReg(IntRegIndex reg, RegVal data);
    RegVal readReg(IntRegIndex reg);
    void memBarrier(Addr addr, uint8_t *data, uint32_t size, bool is_write);


    //读写指令
    uint32_t readInst(Addr addr);
    void writeInst(Addr addr , uint32_t inst);




    //递归深度
    uint32_t getRecurDepth();
    void dumpFrame();

protected:
    FISystem(AtomicSimpleCPU *_cpu);

private:
    AtomicSimpleCPU *cpu;
    TheISA::PCState pc;
    SimpleExecContext *xc;
    SimpleThread *thread;
    EmulationPageTable *pTable; //page table
    RequestPtr iwrite_req;


    //enable flag
    bool enable;
    std::string work_dir;
    std::string config_file;

    //debug info
    DebugInfo *di;
    CompilationUnit *mcu;

    // config
    IniManager *config;

    //FI
    FaultInject *FI;

    //frame info
    Frame *frame; //current frame
    std::stack<Frame *> fstack;

    //mem cache
    LFUCache memCache;
    LRUCache memRecords;
    void collectInfo();

    bool initFI();
    //find config and set work dir
    bool initEnv();


};

#endif
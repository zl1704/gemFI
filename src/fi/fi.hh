#ifndef __FI_HH__
#define __FI_HH__
#include <string>
#include "arch/types.hh"
#include "cpu/op_class.hh"
#include "fi/compile_info.hh"
#include "fi/ini_reader.hh"

#include "fi/profile.hh"

class FISystem;
namespace Trace {
    class InstRecord;
};


class FILogger
{
public:
    FILogger()
    {
    }

    bool addInfo(std::string key, std::string value);

    void dump();

    void dump(std::string filename);

private:
    void dump(std::ostream& os);
    std::map<std::string, std::vector<std::string>> info;
    //按优先级排个序
    std::vector<std::string> keyArr = {"FIType", "Section", "FIFun", "Line", "Fcount", "InstType","Floc","Offset", "Addr", "P-FI", "A-FI"};
};

typedef enum
{
    RANDOM,
    FIXED
} FITYPE;

class FaultInject
{

public:
    virtual void preExecute() {}
    virtual void execute() {}
    virtual void postExecute();
    virtual void Finish();

    static FaultInject *create(IniManager *config, FISystem *fiSystem);

protected:
    FISystem *fiSystem;
    bool finish;
    bool random;
    bool printFlag;
    std::string file;
    int32_t line;
    Function *function;

    //多位注入时使用
    uint8_t fcount;
    //日志
    FILogger logger;

    bool  log_flag{false};

    ProgramProfile programProfiler;

    FaultInject(FISystem *_fiSystem, IniManager *config);
    bool inUserFun();
    Function* getCurFun();
    bool checkExec();
    void readFLData(IniManager *confi);
    void InitProfile(std::string profile_file);
    void ranPickFun();
    bool doFIProcess() { return true; };
    
    
    static bool ranTrigger(uint64_t from, uint64_t to, uint64_t cur, uint32_t rdepth = 1);
    static uint64_t ranFlip(uint64_t data, uint8_t size = 32, uint8_t fc = 8);
    static uint64_t ranFlip(uint64_t data, uint8_t from, uint8_t to, uint8_t fc);
    static uint64_t mflip(uint64_t data ,std::vector<uint8_t> ids);
    static uint64_t flip(uint64_t data, uint8_t pos);

public:
    static uint64_t genRan(uint64_t from, uint64_t to);
    void dump();
    static FITYPE fiType(std::string val);

    virtual std::string name() { return "FaultInject"; }
};

class VarFI : public FaultInject
{
public:
    virtual void preExecute() {}
    virtual void execute();

    virtual std::string name() { return "VarFI"; }

    VarFI(FISystem *fiSystem, IniManager *config);



private:
    Variable *var;
};

class REGFI : public FaultInject
{
public:
    virtual void preExecute() {}
    virtual void execute();
    virtual std::string name() { return "REGFI"; }

    REGFI(FISystem *fiSystem, IniManager *config);



private:
    int string2RegIndex(std::string reg);
    int reg_index;
};

class MemFI : public FaultInject
{
public:
    virtual void preExecute() {}
    virtual void execute();
    virtual std::string name() { return "MEMFI"; }
    MemFI(FISystem *fiSystem, IniManager *config);


};
/**
 *  Control Unit
 * */
class CUFI : public FaultInject
{
public:
    virtual void preExecute();
    virtual void execute();
    virtual std::string name() { return "CUFI"; }
    CUFI(FISystem *fiSystem, IniManager *config);


};

class DpuFI : public FaultInject
{
public:
    virtual void preExecute();
    virtual void execute();
    virtual void postExecute();
    virtual std::string name() { return "DPUFI"; }
    DpuFI(FISystem *fiSystem, IniManager *config);



private:
    typedef enum
    {
        FIOC = 1,
        FIRN = 2,
        FIRD = 3,
        FIOP2 = 4
    } FIP;

    //RR类型 指令
    void processRRInst();
    //RI类型 指令
    void processRIInst();
    //RR-Shift类型 指令
    void processRRSInst();

    void fiRROp2();
    void fiRRSOp2();
    void fiRIOp2();

    void init();
    void fiOpcode();
    void fiRn();
    void fiRd();
    void fiOp2();
    bool isRd;
    std::vector<uint32_t> aluops;
    ArmISA::MachInst inst;

    
};

class MpuFI : public FaultInject
{

public:
    virtual void preExecute() {}
    virtual void execute();
    // virtual void postExecute() {}
    virtual std::string name() { return "MpuFI"; }
    MpuFI(FISystem *fiSystem, IniManager *config);

protected:
    bool doFIProcess();

private:
    void printTlb();
};

//Pre Fetch Unit

class PFUFI : public FaultInject
{

public:
    virtual void preExecute();
    virtual void execute();
    // virtual void postExecute() {}
    virtual std::string name() { return "PFUFI"; }
    PFUFI(FISystem *fiSystem, IniManager *config);

protected:

    static const uint8_t inst_queue_size = 8;
};

//cache
class CacheFI : public FaultInject
{

public:
    virtual void preExecute() {}
    virtual void execute();
    // virtual void postExecute() {}
    virtual std::string name() { return "CACHEFI"; }
    CacheFI(FISystem *fiSystem, IniManager *config);


};

struct InjectEntry
{
    uint32_t _addr;
    //翻转的位
    std::vector<uint8_t> fids;
    InjectEntry(uint32_t addr):_addr(addr){}

};
/**
 *  多位翻转生成
 * */
class MBU
{

public:
    static std::vector<InjectEntry> genEntries(uint32_t addr, uint8_t count, uint32_t align);

    //垂直方向
    static std::vector<InjectEntry> genVertical(uint32_t addr, uint8_t count, uint32_t align );
    //水平
    static std::vector<InjectEntry> genHorizontall(uint32_t addr, uint8_t count,uint32_t align);

    //L
    static std::vector<InjectEntry> genL(uint32_t addr, uint8_t count, uint32_t align);

};

/**
 *   Profile
 * */

class Profiler : public FaultInject{
public:
    virtual void postExecute() ;
    Profiler(FISystem *fiSystem, IniManager *config);
    void Finish();
private:

    
    
    void CountInst();
    void RecordBlockAddr();
    Trace::InstRecord *traceData{nullptr};
    Addr prevReadAddr;
    ArmISA::MachInst inst;
    ArmISA::MachInst preInst;
    std::string curFun;
    
    
};

//===================TEST========================

/**
 *   Bus
 * */
class BusFI : public FaultInject{
public:
    virtual void postExecute();
    virtual std::string name() { return "BusFI"; }
    BusFI(FISystem *fiSystem, IniManager *config);
    void Finish();
private:

    bool checkExec();
    Enums::OpClass op;
    uint32_t ld_exe_cnt;
    uint32_t st_exe_cnt;    
    Trace::InstRecord *traceData;
    Addr prevReadAddr;
    RegIndex prevRegIdx;
};

/**
 *  Reg  
 **/
class RegFI : public FaultInject{
public:
    virtual void postExecute();
    virtual void preExecute() ;
    virtual std::string name() { return "RegFI"; }
    RegFI(FISystem *fiSystem, IniManager *config);

private:
    Trace::InstRecord *traceData;
    bool checkPostExec();
    bool checkPreExec();

};


/**
 * CpuCtr
 * */

// class CpuCtrFI : public FaultInject{

// };




#endif
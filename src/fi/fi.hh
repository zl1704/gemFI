#ifndef __FI_HH__
#define __FI_HH__
#include <string>

#include "fi/compile_info.hh"
#include "fi/ini_reader.hh"
#include "arch/types.hh"
class FISystem;
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
    std::vector<std::string> keyArr = {"FIType", "Section", "FIFun", "Line", "Fcount", "InstType","Floc", "Addr", "P-FI", "A-FI"};
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
    static FaultInject *create(IniReader *config, FISystem *fiSystem);

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

    FaultInject(FISystem *_fiSystem, IniReader *config);
    bool checkExec();
    void readFLData(IniReader *confi);
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

    VarFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; };

private:
    Variable *var;
};

class REGFI : public FaultInject
{
public:
    virtual void preExecute() {}
    virtual void execute();
    virtual std::string name() { return "REGFI"; }

    REGFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; };

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
    MemFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; };
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
    CUFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; };
};

class DpuFI : public FaultInject
{
public:
    virtual void preExecute();
    virtual void execute();
    virtual void postExecute();
    virtual std::string name() { return "DPUFI"; }
    DpuFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; };

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

    bool log_flag;
};

class MpuFI : public FaultInject
{

public:
    virtual void preExecute() {}
    virtual void execute();
    // virtual void postExecute() {}
    virtual std::string name() { return "MpuFI"; }
    MpuFI(FISystem *fiSystem, IniReader *config);

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
    PFUFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; }
};

//cache
class CacheFI : public FaultInject
{

public:
    virtual void preExecute() {}
    virtual void execute();
    // virtual void postExecute() {}
    virtual std::string name() { return "CACHEFI"; }
    CacheFI(FISystem *fiSystem, IniReader *config);

protected:
    bool doFIProcess() { return true; }
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

#endif
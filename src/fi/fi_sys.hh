#ifndef __FI_SYS_HH_
#define __FI_SYS_HH_
#include "cpu/simple/atomic.hh"
#include "fi/fi.hh"
#include <vector>
#include <map>
#include <string>
#define UNSIGNEDMAX (1ULL  << 63)-1

class Range{
public:
    Addr start;
    Addr end;
    Range(){
        start = UNSIGNEDMAX;
        end = 0;
    }
};

class PCInfo{
private:
    std::vector<Range> local_ranges;
    std::map<std::string,Range> rmap;
public:
    void insert(std::string name,Addr pc);
    void dump();

};



class FISystem{
public:
    static FISystem* create(AtomicSimpleCPU* cpu);
    void process();
    void close();
    void startTick();


protected:
    FaultInject* pcFI;
    FaultInject* regFI;
    FaultInject* memFI;
    FISystem(AtomicSimpleCPU* _cpu);



private:
    AtomicSimpleCPU* cpu;
    TheISA::PCState pc;
    PCInfo pcInfo;

    void collectInfo();

    
};

#endif
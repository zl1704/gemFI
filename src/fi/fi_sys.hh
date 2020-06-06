#ifndef __FI_SYS_HH_
#define __FI_SYS_HH_

#include "cpu/simple/atomic.hh"
#include "fi/fi.hh"


class FISystem{
public:
    static FISystem* create(AtomicSimpleCPU* cpu);
    void process();


protected:
    FaultInject* pcFI;
    FaultInject* regFI;
    FaultInject* memFI;
    FISystem(AtomicSimpleCPU* _cpu);



private:
    AtomicSimpleCPU* cpu;
    
};

#endif
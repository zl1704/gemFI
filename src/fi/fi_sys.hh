#include "fi.hh"
#include "cpu/simple/atomic.hh"

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
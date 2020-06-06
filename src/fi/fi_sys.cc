#include "fi_sys.hh"


FISystem::FISystem(AtomicSimpleCPU* _cpu):cpu(_cpu){

    pcFI = new PCFaultInject();

}


FISystem* FISystem::create(AtomicSimpleCPU* cpu){
    

    return new FISystem(cpu);
}


void process(){
    //判断当前环境是否进行故障注入

    //进行故障注入类型





}
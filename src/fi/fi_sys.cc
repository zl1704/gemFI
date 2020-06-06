#include "fi/fi_sys.hh"
#include "base/trace.hh"
#include "base/loader/symtab.hh"
using namespace std;

void PCInfo::insert(std::string name,Addr pc){
    map<string,Range>::iterator it = rmap.find(name);
    
    Range r;
    
    if(it != rmap.end()){
        r = it->second;
        rmap.erase(name);
    }
    if(pc < r.start)
        r.start = pc;
    if(pc > r.end)
        r.end = pc;

    rmap.insert(pair<string,Range>(name,r));

}

void PCInfo::dump(){

    
    cprintf("=======PCInfo::dump=========\n");
    for(map<string,Range>::iterator it = rmap.begin();it!=rmap.end();it++){
        cprintf("fun name:%s, start: %d , end: %d\n",it->first,it->second.start,it->second.end);

    }



}


FISystem::FISystem(AtomicSimpleCPU* _cpu):cpu(_cpu){

    pcFI = new PCFaultInject();

}


FISystem* FISystem::create(AtomicSimpleCPU* cpu){
    
    
    return new FISystem(cpu);
}

void FISystem::collectInfo(){

    // cpu->
    // StaticInstPtr &curInst = cpu->curStaticInst;
    std::string sym_str;
    Addr sym_addr = 0;
    Addr cur_pc = pc.instAddr();
    if(!FullSystem){
        debugSymbolTable->findNearestSymbol(cur_pc, sym_str, sym_addr);
        pcInfo.insert(sym_str,cur_pc);
    }
}

void FISystem::process(){
    //收集信息   故障注入

    collectInfo();


    //判断当前环境是否进行故障注入

    //进行故障注入类型





}
void FISystem::startTick(){

    pc = cpu->threadInfo[cpu->curThread]->pcState();
}



void FISystem::close(){

    cprintf("FISystem::close\n");
    // pcInfo.dump();
}
#include "profile.hh"
#include "compile_info.hh"
#include "fi_sys.hh"
#include "util.hh"
using namespace Profile;
using namespace std;
void ProgramProfile::FromFile(std::string file_name,FISystem* fiSystem){
    IniManager profile;
    bool result = profile.readFromFile(file_name);
    if(!result){
        ccprintf(std::cerr,"can not find profile file : %s \n",file_name.c_str());
        exit(-1);
    }
    std::vector<Function*> funs = fiSystem->getAllFunctions();
    
    for(Function* fun :funs){
        std::map<std::string, std::string> pkvs  = profile.getKVs(fun->getName());
        FunProfile* fp= new FunProfile;
        to_number<uint32_t>(pkvs[LD_ECOUNT],fp->ld_ecnt);
        to_number<uint32_t>(pkvs[ST_ECOUNT],fp->st_ecnt);
        to_number<uint32_t>(pkvs[BUS_LD_ECOUNT],fp->bus_ld_ecnt);
        to_number<uint32_t>(pkvs[VCOUNT],fp->vcnt);
        to_number<int64_t>(pkvs[ECOUNT],fp->ecnt);
        vector<string> blocks = util::splitLine(pkvs[BLOCK_ADDR],' ');
        for(string blockAddr : blocks){
            Addr addr = 0;
            to_number<Addr>(blockAddr,addr);
            fp->block_head_addrs.insert(addr);
        }

        funInfos[fun->getName()] = fp;
    }
}

void ProgramProfile::Dump(std::string file_name){
    IniManager profile;
    for(auto funInfo : funInfos){
        profile.addSection(funInfo.first);
        profile.addKey(funInfo.first,LD_ECOUNT,to_string(funInfo.second->ld_ecnt));
        profile.addKey(funInfo.first,ST_ECOUNT,to_string(funInfo.second->st_ecnt));
        profile.addKey(funInfo.first,BUS_LD_ECOUNT,to_string(funInfo.second->bus_ld_ecnt));
        profile.addKey(funInfo.first,VCOUNT,to_string(funInfo.second->vcnt));
        profile.addKey(funInfo.first,ECOUNT,to_string(funInfo.second->ecnt));
        std::string blocks = "";
        for(auto addr : funInfo.second->block_head_addrs){
            blocks = blocks +to_string(addr) + " ";
        }
        profile.addKey(funInfo.first,BLOCK_ADDR,blocks);

    }
    profile.writeToFile(file_name);
}

std::string ProgramProfile::GetStrData(std::string fun, std::string atrr){

    return "";
}
int64_t ProgramProfile::GetIntData(std::string fun, std::string attr){
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }

    if(attr == LD_ECOUNT)
        return fpf->ld_ecnt;
    else if(attr == ST_ECOUNT)
        return fpf->st_ecnt;
    else if(attr == BUS_LD_ECOUNT)
        return fpf->bus_ld_ecnt;
    else if(attr == VCOUNT)
        return fpf->vcnt;
    else if(attr == ECOUNT)
        return fpf->ecnt;
 
    return 0;

}

void ProgramProfile::SetIntData(std::string fun, std::string attr,int64_t val){
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }
    if(attr == LD_ECOUNT)
        fpf->ld_ecnt = val;
    else if(attr == ST_ECOUNT)
        fpf->st_ecnt = val;
    else if(attr == BUS_LD_ECOUNT)
        fpf->bus_ld_ecnt = val;
    else if(attr == VCOUNT)
        fpf->vcnt = val;
    else if(attr == ECOUNT)
        fpf->ecnt = val;
}

void ProgramProfile::SetStrData(std::string fun, std::string attr,std::string val){
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }

}

void ProgramProfile::AddBlockAddr(std::string fun, uint32_t addr)
{
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }
    fpf->block_head_addrs.insert(addr);
}
std::unordered_set<uint32_t> ProgramProfile::GetBlockAddrs(std::string fun){
    FunProfile* fpf = funInfos[fun];
    if(!fpf)
        return {};
    return fpf->block_head_addrs;
}
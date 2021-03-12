#include "profile.hh"
#include "compile_info.hh"
#include "fi_sys.hh"
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
        fp->ld_ecnt = stoi(pkvs[LD_ECOUNT]);
        fp->st_ecnt = stoi(pkvs[ST_ECOUNT]);
        funInfos[fun->getName()] = fp;
    }
}

void ProgramProfile::Dump(std::string file_name){
    IniManager profile;
    for(auto funInfo : funInfos){
        profile.addSection(funInfo.first);
        profile.addKey(funInfo.first,"LD_ECount",to_string(funInfo.second->ld_ecnt));
        profile.addKey(funInfo.first,"ST_ECount",to_string(funInfo.second->st_ecnt));
    }
    profile.writeToFile(file_name);
}

std::string ProgramProfile::GetStrData(std::string fun, std::string atrr){

    return "";
}
int ProgramProfile::GetIntData(std::string fun, std::string attr){
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }

    if(attr == LD_ECOUNT)
        return fpf->ld_ecnt;
   else if(attr == ST_ECOUNT)
        return fpf->st_ecnt;
 
    return 0;

}

void ProgramProfile::SetIntData(std::string fun, std::string attr,int val){
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }
    if(attr == LD_ECOUNT)
        fpf->ld_ecnt = val;
   else if(attr == ST_ECOUNT)
        fpf->st_ecnt = val;
}

void ProgramProfile::SetStrData(std::string fun, std::string attr,std::string val){
    FunProfile* fpf = funInfos[fun];
    if(!fpf){
        fpf = new FunProfile;
        funInfos[fun] = fpf;
    }

}
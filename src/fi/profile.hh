#ifndef __PROFILE_HH__
#define __PROFILE_HH__
#include <string>
#include <unordered_map>
#include "ini_reader.hh"
namespace Profile{
    static  std::string LD_ECOUNT = "LDECount";
    static  std::string ST_ECOUNT = "STECount";
    static  std::string BUS_LD_ECOUNT = "BusLDECount";

}

class FunProfile{
public:
    uint32_t ld_ecnt{0};
    uint32_t st_ecnt{0};    
    uint32_t bus_ld_ecnt{0};
    
};
class FISystem;
class ProgramProfile{
public:
    void FromFile(std::string file_name,FISystem* fiSystem);
    void Dump(std::string file_name);
    std::string GetStrData(std::string fun, std::string attr);
    int GetIntData(std::string fun, std::string attr);
    void SetStrData(std::string fun, std::string attr,std::string val);
    void SetIntData(std::string fun, std::string attr,int val);
private:

    std::unordered_map<std::string,FunProfile*> funInfos;

};



#endif
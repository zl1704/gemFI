#ifndef __PROFILE_HH__
#define __PROFILE_HH__
#include <string>
#include <unordered_map>
#include <unordered_set>

#include "ini_reader.hh"
namespace Profile{
    static  std::string ECOUNT = "ECount";
    static  std::string LD_ECOUNT = "LDECount";
    static  std::string ST_ECOUNT = "STECount";
    static  std::string VCOUNT = "VCOUNT";
    static  std::string BUS_LD_ECOUNT = "BusLDECount";
    static  std::string BLOCK_ADDR = "BlockAddr";

}

class FunProfile{
public:
    int64_t ecnt{0};
    uint32_t ld_ecnt{0};
    uint32_t st_ecnt{0};    
    uint32_t bus_ld_ecnt{0};
    uint32_t vcnt{0};
    std::unordered_set<uint32_t> block_head_addrs;
    
    
};
class FISystem;
class ProgramProfile{
    friend class Profiler;
public:
    void FromFile(std::string file_name,FISystem* fiSystem);
    void Dump(std::string file_name);
    std::string GetStrData(std::string fun, std::string attr);
    int64_t GetIntData(std::string fun, std::string attr);
    void SetStrData(std::string fun, std::string attr,std::string val);
    void SetIntData(std::string fun, std::string attr,int64_t val);
    void AddBlockAddr(std::string fun , uint32_t addr);
    std::unordered_set<uint32_t> GetBlockAddrs(std::string fun);

private:

    std::unordered_map<std::string,FunProfile*> funInfos;

};



#endif
//
// Created by zl on 2020/6/17.
//

#ifndef _UTIL_HH_
#define _UTIL_HH_
#include <stdarg.h>
#include <string>
#include <vector>

namespace  util{
    extern  uint8_t debug ;
    //block data

    std::vector<std::string> splitLine(const std::string &line, char delim);
    uint8_t leb128u(char *s, uint64_t &result) ;
    uint8_t leb128s(char *s, int64_t &result) ;
    void printf_d(uint8_t debug_level,std::string format, ...) ;
     template <typename T>
    T strToNum(std::string str);
    void convertDataToArr(uint64_t data,uint8_t* da);
    


    
}


#endif //_UTIL_HH_

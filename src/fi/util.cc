//
// Created by zl on 2020/6/17.
//
// #include <libdwarf.h>
#include "fi/util.hh"
#include <iostream>
#include <sstream> //使用stringstream需要引入这个头文件
#include <fstream>
#include <ctime>
namespace util
{
    using namespace std;
    uint8_t debug = 0;

    uint8_t leb128u(char *s, uint64_t &result)
    {
        uint64_t shift = 0;
        uint8_t bnum = 0;
        result = 0;
        while (1)
        {
            uint8_t byte = *s;
            s++;
            result |= (byte & 0x7f) << shift;
            bnum++;
            if ((byte & 0x80) == 0)
            {
                break;
            }
            shift += 7;
            if (shift >= (sizeof(result) * 8))
            {
                fprintf(stderr, "Value too big\n");
                exit(1);
            }
        }

        return bnum;
    }

    uint8_t leb128s(char *s, int64_t &result)
    {
        uint64_t shift = 0;
        uint8_t bnum = 0;
        uint8_t byte;
        result = 0;
        do
        {
            byte = *s;
            s++;
            result |= (byte & 0x7f) << shift;
            shift += 7;
            bnum++;
        } while (byte & 0x80);

        /* sign bit of byte is second high order bit (0x40) */
        if (0x40 & byte)
            result |= ((uint64_t)~0 << shift); /* sign extend */

        return bnum;
    }

    void printf_d(uint8_t debug_level, std::string format, ...)
    {

        if (debug < debug_level)
            return;
        va_list ap;
        va_start(ap, format);
        vprintf(format.c_str(), ap);
        va_end(ap);
    }
    void convertDataToArr(uint64_t data, uint8_t *da)
    {
        da[0] = data;
        da[1] = data >> 8;
        da[2] = data >> 16;
        da[3] = data >> 24;
    }

    template <typename T>
    T strToNum(std::string str)
    {
        T t;
        std::stringstream oss; //创建一个格式化输出流
        oss << str;            //把值传递如流中
        oss >> t;
        return t;
    }
    template uint8_t strToNum<uint8_t>(string str);
    template uint32_t strToNum<uint32_t>(string str);
    template int32_t strToNum<int32_t>(string str);

} // namespace util

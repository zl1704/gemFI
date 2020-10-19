#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#define random(a,b) (((double)rand()/RAND_MAX)*(b-a)+a)

int commandListLen;//命令字符个数
char *commandList[1000];//命令行
typedef struct Data
{
    int Id;
    double Longitude;//经度
    double Latitude;//纬度
}Data;
struct Data * readTxtFile(const char* txtFilePath,struct Data *DataBuff,int *len)
{
    char buf[1000];
    FILE *fin;
    char *p;
    fin = fopen(txtFilePath, "r");//只读
    
    if(fin==NULL)printf("file cannot open %s\n",txtFilePath);
    else
    {
        int i=1;
        int j=0;
        while (!feof(fin))
        {
            fgets(buf, 1000, fin); //读取文件中的一行到buf中
            // strtok函数用于分割buf中的字符串，分割符号都写在第二个参数中s
            for (p = strtok(buf, " \t\r\n"); p; p = strtok(NULL, " \t\r\n"))
            {
                if(i%3==1){
                    DataBuff[j].Id=atoi(p);//char*转int
                    //printf("%d\n", DataBuff[j].Id);
                    i++;
                }
                else if(i%3==2){
                    DataBuff[j].Longitude=strtod(p,NULL);//char*转double
                    //printf("%f\n", DataBuff[j].Longitude);
                    i++;
                }
                else if(i%3==0){
                    DataBuff[j].Latitude=strtod(p,NULL);//char*转double
                    //printf("%f\n", DataBuff[j].Latitude);
                    i++;
                    j++;
                }
            }
        }
        fclose(fin);
        *len=j;
    }
    return DataBuff;
}
void writeTxtFile(const char* txtFilePath,struct Data *Databuff,int len)
{
    FILE *fout;
    fout= fopen(txtFilePath, "w");//只写
    if (fout==NULL) {
        printf("file cannot open %s\n",txtFilePath);
        exit(0);
    }
    else {
        for(int i=0;i<len;i++)
        {
            fprintf(fout,"%d ",Databuff[i].Id);
            //printf("%d\n",Databuff[i].Id);
            fprintf(fout,"%f ",Databuff[i].Longitude);
            fprintf(fout,"%f\n",Databuff[i].Latitude);
        }
        fclose(fout);
    }
}
int insertData(const char* txtFilePath,Data data)//插入数据
{
    FILE *fout;
    fout= fopen(txtFilePath, "a+");//以读写的方式对一个文件进行追加
    if (fout==NULL) {
        printf("file cannot open %s\n",txtFilePath);
        return 0;
    }
    else {
        fprintf(fout,"%d ",data.Id);
        //printf("%d ",data.Id);
        fprintf(fout,"%f ",data.Longitude);
        fprintf(fout,"%f\n",data.Latitude);
        fclose(fout);
        return 1;
    }
}
int deleteData(const char* txtFilePath,int ID)//删除数据
{
    struct  Data * DataBuff;
    DataBuff=(struct Data *)malloc(1000*sizeof(struct Data));
    int len=0;
    readTxtFile(txtFilePath,DataBuff,&len);
    int flag = 0;
    int nowLen=len;
    for (int i=0;i<len;i++)
    {
        if (DataBuff[i].Id == ID)
        {
            for(int j=i;j<len;j++)
            {
                DataBuff[j].Id=DataBuff[j+1].Id;
                DataBuff[j].Longitude=DataBuff[j+1].Longitude;
                DataBuff[j].Latitude=DataBuff[j+1].Latitude;
            }
            nowLen--;
            flag = 1;
        }
    }
    len=nowLen;
    if (flag == 0)
    {
        printf("ID不存在，无法删除\n");
        return 0;
    }
    else
    {
        writeTxtFile(txtFilePath,DataBuff,len);//重新写回
        return 1;
    }
}
int findData(const char* txtFilePath, int ID)//查询数据
{
    struct  Data * DataBuff;
    DataBuff=(struct Data *)malloc(1000*sizeof(struct Data));
    int len=0;
    DataBuff= readTxtFile(txtFilePath,DataBuff,&len);
    int findFlag = 0;
    for (int i=0;i<len;i++)
    {
        if (DataBuff[i].Id == ID)
        {
            findFlag =1;
            printf("%s%15s%15s\n","ID","Longitude","Latitude");
            printf("%d%15f%15f\n",DataBuff[i].Id,DataBuff[i].Longitude,DataBuff[i].Latitude);
        }
    }
    if(findFlag==1)return 1;
    else return 0;
}
void generateData(const char* txtFilePath,int numOfData)//生成初始数据
{
    FILE *fout;
    fout= fopen(txtFilePath, "w");//只写
    if (fout==NULL) {
        printf("file cannot open %s\n",txtFilePath);
        exit(0);
    }
    else {
        for (int i=0;i<numOfData;i++)
        {
            fprintf(fout,"%d ",i);
            fprintf(fout,"%f ",random(20.0,25.0));
            fprintf(fout,"%f ",random(220.0,225.0));
            if (i != numOfData-1)
                fprintf(fout,"\n" );
        }
        fclose(fout);
    }
}
void layout()
{
    printf("********************\n\n");
    printf("数据管理系统\n\n");
    printf("insert: 插入数据\n\n");
    printf("delete: 删除数据\n\n");
    printf("inquire: 查询数据\n\n");
    printf("inquireAll:查看全部数据\n\n" );
    printf("exit:退出\n\n");
    printf("********************\n\n");
}
int readCommandTxt(const char* txtFilePath)
{
    char buf[1000];
    FILE *fin;
    char *p;
    fin = fopen(txtFilePath, "r");//只读
    commandListLen=0;//文件中字符串个数
    if(fin==NULL)
    {
        printf("file cannot open %s\n",txtFilePath);
        return 0;
    }
    else
    {
        while (!feof(fin))
        {
            fgets(buf, 1000, fin); //读取文件中的一行到buf中
            // strtok函数用于分割buf中的字符串，分割符号都写在第二个参数中s
            for (p = strtok(buf, " \t\r\n"); p; p = strtok(NULL, " \t\r\n"))
            {
                commandList[commandListLen]=(char*)malloc(strlen(p)+1);
                strcpy(commandList[commandListLen],p);
                commandListLen++;
            }
        }
        fclose(fin);
    }
    return 1;
}
int main()
{
    layout();
    readCommandTxt("command.txt");
    char choose[20];
    int commandID=0;
            int commandIDJG=commandID;
    int nowstr=0;
            int nowstrJG=nowstr;
            if(nowstrJG!=nowstr)
            {
                printf("error is detected!\n");
                exit(0);
            }
    if (nowstr<commandListLen)
    {
            if(nowstrJG!=nowstr)
            {
                printf("error is detected!\n");
                exit(0);
            }
        strcpy(choose,commandList[nowstr++]);
            nowstrJG=nowstr;
        printf("%s\n",choose );
    }
    while(strcmp (choose,"exit")!=0)
    {
        if (strcmp(choose,"insert")==0)
        {
            commandID = 1;
                commandIDJG = commandID;
        }
        else if (strcmp (choose,"delete")==0)
        {
            commandID = 2;
                commandIDJG = commandID;
        }
        else if (strcmp (choose,"inquire")==0)
        {
            commandID = 3;
                commandIDJG = commandID;
        }
        else if (strcmp (choose,"inquireAll")==0)
        {
            commandID = 4;
                commandIDJG = commandID;
        }
        if(commandID!=commandIDJG)
        {
            printf("error is detected!\n");
            exit(0);
        }
        switch (commandID)
        {
            case 1:
            {
                Data data;
                data.Id=0;
                   int IdJG = data.Id;
                data.Latitude=0.0;
                   double LatitudeJG = data.Latitude;
                data.Longitude=0.0;
                   double LongitudeJG = data.Longitude;
                int flag = 0;
                   int flagJG = flag;
                printf( "插入数据" );
                printf("ID:");
                if (nowstr<commandListLen)
                {
                    if(nowstrJG!=nowstr)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    data.Id =atoi(commandList[nowstr++]);
                        IdJG = data.Id;
                        nowstrJG = nowstr;
                    if(IdJG!=data.Id)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    printf("%d\n",data.Id );
                }
                printf("Longtitude:");
                if (nowstr<commandListLen)
                {
                    if(nowstrJG!=nowstr)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    data.Longitude =strtod(commandList[nowstr++],NULL);
                        LongitudeJG = data.Longitude;
                        nowstrJG = nowstr;
                    if(LongitudeJG!=data.Longitude)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    printf("%f\n",data.Longitude );
                }
                printf("Latitude:");
                if (nowstr<commandListLen)
                {
                    if(nowstrJG!=nowstr)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    data.Latitude =strtod(commandList[nowstr++],NULL);
                        LatitudeJG = data.Latitude;
                        nowstrJG = nowstr;
                    if(LatitudeJG!=data.Latitude)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    printf("%f\n",data.Latitude );
                }
                flag = insertData("exampleDataFile.txt", data);
                    flagJG = flag;
                if(flagJG!=flag)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (flag == 1)printf("数据插入成功\n");
                else printf("数据插入失败\n");
                layout();
                if(nowstrJG!=nowstr)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (nowstr<commandListLen)
                {
                    strcpy(choose,commandList[nowstr++]);
                        nowstrJG=nowstr;
                    printf("%s\n",choose );
                }
            }
                break;
            case 2:
            {
                double id=-1;
                    double idJG = id;
                printf("删除数据\n\n");
                printf("请输入ID\n" );
                if(nowstrJG!=nowstr)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (nowstr<commandListLen)
                {
                    id=strtod(commandList[nowstr++],NULL);
                        idJG = id;
                        nowstrJG=nowstr;
                    printf("%f\n",id);
                }
                if(idJG!=id)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                deleteData("exampleDataFile.txt", id);
                layout();
                if(nowstrJG!=nowstr)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (nowstr<commandListLen)
                {
                    strcpy(choose,commandList[nowstr++]);
                        nowstrJG=nowstr;
                    printf("%s\n",choose );
                }
            }
                break;
            case 3:
            {
                double id=-1;
                    double idJG = id;
                int flag=0;
                    int flagJG = flag;
                printf("查询数据\n\n" );
                printf("请输入ID\n");
                if(nowstrJG!=nowstr)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if(nowstr<commandListLen)
                {
                    id=strtod(commandList[nowstr++],NULL);
                        idJG = id;
                        nowstrJG=nowstr;
                    if(idJG!=id)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    printf("%f\n",id);
                }
                if(idJG!=id)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                flag = findData("exampleDataFile.txt",id);
                    flagJG = flag;
                if(flagJG!=flag)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (flag == 1)printf("查询成功\n");
                else printf("未查询到数据\n");
                layout();
                if(nowstrJG!=nowstr)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (nowstr<commandListLen)
                {
                    strcpy(choose,commandList[nowstr++]);
                        nowstrJG=nowstr;
                    printf("%s\n",choose );
                }
            }
                break;
            case 4:
            {
                struct  Data * DataBuff;
                DataBuff=(struct Data *)malloc(1000*sizeof(struct Data));
                int len=0;
                    int lenJG = len;
                DataBuff= readTxtFile("exampleDataFile.txt",DataBuff,&len);
                printf("%s%15s%15s\n","ID","Longitude","Latitude");
                for(int i=0;i<len;i++)
                {
                        int iJG =i;
                    if(iJG!=i)
                    {
                        printf("error is detected!\n");
                        exit(0);
                    }
                    printf("%d%15f%15f\n",DataBuff[i].Id,DataBuff[i].Longitude,DataBuff[i].Latitude);
                }
                layout();
                if(nowstrJG!=nowstr)
                {
                    printf("error is detected!\n");
                    exit(0);
                }
                if (nowstr<commandListLen)
                {
                    strcpy(choose,commandList[nowstr++]);
                        nowstrJG = nowstr;
                    printf("%s\n",choose );
                }
            }
                break;
            default:
            {
                printf("未识别的命令\n");
            }
                break;
        }
    }
}



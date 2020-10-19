; ModuleID = 'Test_cf.ll'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"find control error!\0A\00", align 1
@main.a = private unnamed_addr constant [12 x i32] [i32 2, i32 64, i32 1, i32 23, i32 425, i32 64, i32 2, i32 14, i32 9, i32 2, i32 5, i32 7], align 16
@.str1 = private unnamed_addr constant [5 x i8] c"%d  \00", align 1
@.str2 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@gSig = global i32 0
@NTSSig = global i32 0
@SPSSig = global i32 0

; Function Attrs: nounwind uwtable
define void @exc(i32* %a, i32 %i, i32 %j) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %temp = alloca i32, align 4
  store i32* %a, i32** %1, align 8
  call void @llvm.dbg.declare(metadata !{i32** %1}, metadata !26), !dbg !27
  store i32 %i, i32* %2, align 4
  call void @llvm.dbg.declare(metadata !{i32* %2}, metadata !28), !dbg !27
  store i32 %j, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !29), !dbg !27
  call void @llvm.dbg.declare(metadata !{i32* %temp}, metadata !30), !dbg !31
  %4 = load i32* %2, align 4, !dbg !31
  %5 = sext i32 %4 to i64, !dbg !31
  %6 = load i32** %1, align 8, !dbg !31
  %7 = getelementptr inbounds i32* %6, i64 %5, !dbg !31
  %8 = load i32* %7, align 4, !dbg !31
  store i32 %8, i32* %temp, align 4, !dbg !31
  %9 = load i32* %3, align 4, !dbg !32
  %10 = sext i32 %9 to i64, !dbg !32
  %11 = load i32** %1, align 8, !dbg !32
  %12 = getelementptr inbounds i32* %11, i64 %10, !dbg !32
  %13 = load i32* %12, align 4, !dbg !32
  %14 = load i32* %2, align 4, !dbg !32
  %15 = sext i32 %14 to i64, !dbg !32
  %16 = load i32** %1, align 8, !dbg !32
  %17 = getelementptr inbounds i32* %16, i64 %15, !dbg !32
  store i32 %13, i32* %17, align 4, !dbg !32
  %18 = load i32* %temp, align 4, !dbg !33
  %19 = load i32* %3, align 4, !dbg !33
  %20 = sext i32 %19 to i64, !dbg !33
  %21 = load i32** %1, align 8, !dbg !33
  %22 = getelementptr inbounds i32* %21, i64 %20, !dbg !33
  store i32 %18, i32* %22, align 4, !dbg !33
  ret void, !dbg !34
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @partition(i32* %a, i32 %lo, i32 %hi) #0 {
  %1 = load i32* @NTSSig
  store i32 0, i32* @NTSSig
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %v = alloca i32, align 4
  store i32* %a, i32** %2, align 8
  call void @llvm.dbg.declare(metadata !{i32** %2}, metadata !35), !dbg !36
  store i32 %lo, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !37), !dbg !36
  store i32 %hi, i32* %4, align 4
  call void @llvm.dbg.declare(metadata !{i32* %4}, metadata !38), !dbg !36
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !39), !dbg !40
  %5 = load i32* %3, align 4, !dbg !40
  store i32 %5, i32* %i, align 4, !dbg !40
  call void @llvm.dbg.declare(metadata !{i32* %j}, metadata !41), !dbg !40
  %6 = load i32* %4, align 4, !dbg !40
  %7 = add nsw i32 %6, 1, !dbg !40
  store i32 %7, i32* %j, align 4, !dbg !40
  call void @llvm.dbg.declare(metadata !{i32* %v}, metadata !42), !dbg !43
  %8 = load i32* %3, align 4, !dbg !43
  %9 = sext i32 %8 to i64, !dbg !43
  %10 = load i32** %2, align 8, !dbg !43
  %11 = getelementptr inbounds i32* %10, i64 %9, !dbg !43
  %12 = load i32* %11, align 4, !dbg !43
  store i32 %12, i32* %v, align 4, !dbg !43
  %13 = load i32* @SPSSig, !dbg !44
  store i32 3, i32* @SPSSig, !dbg !44
  br label %14, !dbg !44

; <label>:14                                      ; preds = %123, %0
  %15 = load i32* @NTSSig, !dbg !45
  %16 = icmp ne i32 0, %15, !dbg !45
  br i1 %16, label %17, label %18

; <label>:17                                      ; preds = %14
  call void @find_err()
  unreachable

; <label>:18                                      ; preds = %14
  store i32 1, i32* @NTSSig, !dbg !45
  br label %proxyBlock, !dbg !45

; <label>:19                                      ; preds = %143, %57
  %20 = load i32* @NTSSig, !dbg !45
  %21 = icmp ne i32 0, %20, !dbg !45
  br i1 %21, label %22, label %23

; <label>:22                                      ; preds = %19
  call void @find_err()
  unreachable

; <label>:23                                      ; preds = %19
  store i32 1, i32* @NTSSig, !dbg !45
  %24 = load i32* %i, align 4, !dbg !45
  %25 = add nsw i32 %24, 1, !dbg !45
  store i32 %25, i32* %i, align 4, !dbg !45
  %26 = sext i32 %25 to i64, !dbg !45
  %27 = load i32** %2, align 8, !dbg !45
  %28 = getelementptr inbounds i32* %27, i64 %26, !dbg !45
  %29 = load i32* %28, align 4, !dbg !45
  %30 = load i32* %v, align 4, !dbg !45
  %31 = icmp slt i32 %29, %30, !dbg !45
  br i1 %31, label %proxyBlock1, label %proxyBlock2, !dbg !45

; <label>:32                                      ; preds = %151
  %33 = load i32* @NTSSig, !dbg !47
  %34 = icmp ne i32 0, %33, !dbg !47
  br i1 %34, label %35, label %36

; <label>:35                                      ; preds = %32
  call void @find_err()
  unreachable

; <label>:36                                      ; preds = %32
  store i32 1, i32* @NTSSig, !dbg !47
  %37 = load i32* %i, align 4, !dbg !47
  %38 = load i32* %4, align 4, !dbg !47
  %39 = icmp eq i32 %37, %38, !dbg !47
  br i1 %39, label %40, label %49, !dbg !47

; <label>:40                                      ; preds = %36
  %41 = load i32* @NTSSig, !dbg !47
  %42 = icmp ne i32 1, %41, !dbg !47
  br i1 %42, label %43, label %44

; <label>:43                                      ; preds = %40
  call void @find_err()
  unreachable

; <label>:44                                      ; preds = %40
  store i32 0, i32* @NTSSig, !dbg !47
  %45 = load i32* @SPSSig, !dbg !47
  %46 = icmp ne i32 5, %45, !dbg !47
  br i1 %46, label %47, label %48

; <label>:47                                      ; preds = %44
  call void @find_err()
  unreachable

; <label>:48                                      ; preds = %44
  store i32 8, i32* @SPSSig, !dbg !47
  br label %58, !dbg !47

; <label>:49                                      ; preds = %36
  %50 = load i32* @NTSSig, !dbg !47
  %51 = icmp ne i32 1, %50, !dbg !47
  br i1 %51, label %52, label %53

; <label>:52                                      ; preds = %49
  call void @find_err()
  unreachable

; <label>:53                                      ; preds = %49
  store i32 0, i32* @NTSSig, !dbg !47
  %54 = load i32* @SPSSig, !dbg !47
  %55 = icmp ne i32 5, %54, !dbg !47
  br i1 %55, label %56, label %57

; <label>:56                                      ; preds = %53
  call void @find_err()
  unreachable

; <label>:57                                      ; preds = %53
  store i32 4, i32* @SPSSig, !dbg !47
  br label %19, !dbg !47

; <label>:58                                      ; preds = %159, %48
  %59 = load i32* @NTSSig, !dbg !49
  %60 = icmp ne i32 0, %59, !dbg !49
  br i1 %60, label %61, label %62

; <label>:61                                      ; preds = %58
  call void @find_err()
  unreachable

; <label>:62                                      ; preds = %58
  store i32 1, i32* @NTSSig, !dbg !49
  br label %proxyBlock3, !dbg !49

; <label>:63                                      ; preds = %167, %101
  %64 = load i32* @NTSSig, !dbg !49
  %65 = icmp ne i32 0, %64, !dbg !49
  br i1 %65, label %66, label %67

; <label>:66                                      ; preds = %63
  call void @find_err()
  unreachable

; <label>:67                                      ; preds = %63
  store i32 1, i32* @NTSSig, !dbg !49
  %68 = load i32* %v, align 4, !dbg !49
  %69 = load i32* %j, align 4, !dbg !49
  %70 = add nsw i32 %69, -1, !dbg !49
  store i32 %70, i32* %j, align 4, !dbg !49
  %71 = sext i32 %70 to i64, !dbg !49
  %72 = load i32** %2, align 8, !dbg !49
  %73 = getelementptr inbounds i32* %72, i64 %71, !dbg !49
  %74 = load i32* %73, align 4, !dbg !49
  %75 = icmp slt i32 %68, %74, !dbg !49
  br i1 %75, label %proxyBlock4, label %proxyBlock5, !dbg !49

; <label>:76                                      ; preds = %175
  %77 = load i32* @NTSSig, !dbg !50
  %78 = icmp ne i32 0, %77, !dbg !50
  br i1 %78, label %79, label %80

; <label>:79                                      ; preds = %76
  call void @find_err()
  unreachable

; <label>:80                                      ; preds = %76
  store i32 1, i32* @NTSSig, !dbg !50
  %81 = load i32* %j, align 4, !dbg !50
  %82 = load i32* %3, align 4, !dbg !50
  %83 = icmp eq i32 %81, %82, !dbg !50
  br i1 %83, label %84, label %93, !dbg !50

; <label>:84                                      ; preds = %80
  %85 = load i32* @NTSSig, !dbg !50
  %86 = icmp ne i32 1, %85, !dbg !50
  br i1 %86, label %87, label %88

; <label>:87                                      ; preds = %84
  call void @find_err()
  unreachable

; <label>:88                                      ; preds = %84
  store i32 0, i32* @NTSSig, !dbg !50
  %89 = load i32* @SPSSig, !dbg !50
  %90 = icmp ne i32 10, %89, !dbg !50
  br i1 %90, label %91, label %92

; <label>:91                                      ; preds = %88
  call void @find_err()
  unreachable

; <label>:92                                      ; preds = %88
  store i32 13, i32* @SPSSig, !dbg !50
  br label %102, !dbg !50

; <label>:93                                      ; preds = %80
  %94 = load i32* @NTSSig, !dbg !50
  %95 = icmp ne i32 1, %94, !dbg !50
  br i1 %95, label %96, label %97

; <label>:96                                      ; preds = %93
  call void @find_err()
  unreachable

; <label>:97                                      ; preds = %93
  store i32 0, i32* @NTSSig, !dbg !50
  %98 = load i32* @SPSSig, !dbg !50
  %99 = icmp ne i32 10, %98, !dbg !50
  br i1 %99, label %100, label %101

; <label>:100                                     ; preds = %97
  call void @find_err()
  unreachable

; <label>:101                                     ; preds = %97
  store i32 9, i32* @SPSSig, !dbg !50
  br label %63, !dbg !50

; <label>:102                                     ; preds = %183, %92
  %103 = load i32* @NTSSig, !dbg !52
  %104 = icmp ne i32 0, %103, !dbg !52
  br i1 %104, label %105, label %106

; <label>:105                                     ; preds = %102
  call void @find_err()
  unreachable

; <label>:106                                     ; preds = %102
  store i32 1, i32* @NTSSig, !dbg !52
  %107 = load i32* %i, align 4, !dbg !52
  %108 = load i32* %j, align 4, !dbg !52
  %109 = icmp sge i32 %107, %108, !dbg !52
  br i1 %109, label %110, label %115, !dbg !52

; <label>:110                                     ; preds = %106
  %111 = load i32* @NTSSig, !dbg !52
  %112 = icmp ne i32 1, %111, !dbg !52
  br i1 %112, label %113, label %114

; <label>:113                                     ; preds = %110
  call void @find_err()
  unreachable

; <label>:114                                     ; preds = %110
  store i32 0, i32* @NTSSig, !dbg !52
  br label %127, !dbg !52

; <label>:115                                     ; preds = %106
  %116 = load i32* @NTSSig, !dbg !54
  %117 = icmp ne i32 1, %116, !dbg !54
  br i1 %117, label %118, label %119

; <label>:118                                     ; preds = %115
  call void @find_err()
  unreachable

; <label>:119                                     ; preds = %115
  store i32 0, i32* @NTSSig, !dbg !54
  %120 = load i32* @SPSSig, !dbg !54
  %121 = icmp ne i32 13, %120, !dbg !54
  br i1 %121, label %122, label %123

; <label>:122                                     ; preds = %119
  call void @find_err()
  unreachable

; <label>:123                                     ; preds = %119
  %124 = load i32** %2, align 8, !dbg !54
  %125 = load i32* %i, align 4, !dbg !54
  %126 = load i32* %j, align 4, !dbg !54
  call void @exc(i32* %124, i32 %125, i32 %126), !dbg !54
  store i32 3, i32* @SPSSig, !dbg !55
  br label %14, !dbg !55

; <label>:127                                     ; preds = %114
  %128 = load i32* @SPSSig, !dbg !56
  %129 = icmp ne i32 13, %128, !dbg !56
  br i1 %129, label %130, label %131

; <label>:130                                     ; preds = %127
  call void @find_err()
  unreachable

; <label>:131                                     ; preds = %127
  %132 = load i32** %2, align 8, !dbg !56
  %133 = load i32* %3, align 4, !dbg !56
  %134 = load i32* %j, align 4, !dbg !56
  call void @exc(i32* %132, i32 %133, i32 %134), !dbg !56
  %135 = load i32* %j, align 4, !dbg !57
  store i32 3, i32* @SPSSig, !dbg !57
  ret i32 %135, !dbg !57

proxyBlock:                                       ; preds = %18
  %136 = load i32* @NTSSig
  %137 = icmp ne i32 1, %136
  br i1 %137, label %138, label %139

; <label>:138                                     ; preds = %proxyBlock
  call void @find_err()
  unreachable

; <label>:139                                     ; preds = %proxyBlock
  store i32 0, i32* @NTSSig
  %140 = load i32* @SPSSig
  %141 = icmp ne i32 3, %140
  br i1 %141, label %142, label %143

; <label>:142                                     ; preds = %139
  call void @find_err()
  unreachable

; <label>:143                                     ; preds = %139
  store i32 4, i32* @SPSSig
  br label %19

proxyBlock1:                                      ; preds = %23
  %144 = load i32* @NTSSig
  %145 = icmp ne i32 1, %144
  br i1 %145, label %146, label %147

; <label>:146                                     ; preds = %proxyBlock1
  call void @find_err()
  unreachable

; <label>:147                                     ; preds = %proxyBlock1
  store i32 0, i32* @NTSSig
  %148 = load i32* @SPSSig
  %149 = icmp ne i32 4, %148
  br i1 %149, label %150, label %151

; <label>:150                                     ; preds = %147
  call void @find_err()
  unreachable

; <label>:151                                     ; preds = %147
  store i32 5, i32* @SPSSig
  br label %32

proxyBlock2:                                      ; preds = %23
  %152 = load i32* @NTSSig
  %153 = icmp ne i32 1, %152
  br i1 %153, label %154, label %155

; <label>:154                                     ; preds = %proxyBlock2
  call void @find_err()
  unreachable

; <label>:155                                     ; preds = %proxyBlock2
  store i32 0, i32* @NTSSig
  %156 = load i32* @SPSSig
  %157 = icmp ne i32 4, %156
  br i1 %157, label %158, label %159

; <label>:158                                     ; preds = %155
  call void @find_err()
  unreachable

; <label>:159                                     ; preds = %155
  store i32 8, i32* @SPSSig
  br label %58

proxyBlock3:                                      ; preds = %62
  %160 = load i32* @NTSSig
  %161 = icmp ne i32 1, %160
  br i1 %161, label %162, label %163

; <label>:162                                     ; preds = %proxyBlock3
  call void @find_err()
  unreachable

; <label>:163                                     ; preds = %proxyBlock3
  store i32 0, i32* @NTSSig
  %164 = load i32* @SPSSig
  %165 = icmp ne i32 8, %164
  br i1 %165, label %166, label %167

; <label>:166                                     ; preds = %163
  call void @find_err()
  unreachable

; <label>:167                                     ; preds = %163
  store i32 9, i32* @SPSSig
  br label %63

proxyBlock4:                                      ; preds = %67
  %168 = load i32* @NTSSig
  %169 = icmp ne i32 1, %168
  br i1 %169, label %170, label %171

; <label>:170                                     ; preds = %proxyBlock4
  call void @find_err()
  unreachable

; <label>:171                                     ; preds = %proxyBlock4
  store i32 0, i32* @NTSSig
  %172 = load i32* @SPSSig
  %173 = icmp ne i32 9, %172
  br i1 %173, label %174, label %175

; <label>:174                                     ; preds = %171
  call void @find_err()
  unreachable

; <label>:175                                     ; preds = %171
  store i32 10, i32* @SPSSig
  br label %76

proxyBlock5:                                      ; preds = %67
  %176 = load i32* @NTSSig
  %177 = icmp ne i32 1, %176
  br i1 %177, label %178, label %179

; <label>:178                                     ; preds = %proxyBlock5
  call void @find_err()
  unreachable

; <label>:179                                     ; preds = %proxyBlock5
  store i32 0, i32* @NTSSig
  %180 = load i32* @SPSSig
  %181 = icmp ne i32 9, %180
  br i1 %181, label %182, label %183

; <label>:182                                     ; preds = %179
  call void @find_err()
  unreachable

; <label>:183                                     ; preds = %179
  store i32 13, i32* @SPSSig
  br label %102
}

; Function Attrs: nounwind uwtable
define void @find_err() #0 {
  %1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([21 x i8]* @.str, i32 0, i32 0)), !dbg !58
  ret void, !dbg !59
}

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind uwtable
define void @sort(i32* %a, i32 %lo, i32 %hi) #0 {
  %1 = load i32* @NTSSig
  store i32 1, i32* @NTSSig
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %j = alloca i32, align 4
  store i32* %a, i32** %2, align 8
  call void @llvm.dbg.declare(metadata !{i32** %2}, metadata !60), !dbg !61
  store i32 %lo, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !62), !dbg !61
  store i32 %hi, i32* %4, align 4
  call void @llvm.dbg.declare(metadata !{i32* %4}, metadata !63), !dbg !61
  %5 = load i32* %4, align 4, !dbg !64
  %6 = load i32* %3, align 4, !dbg !64
  %7 = icmp sle i32 %5, %6, !dbg !64
  br i1 %7, label %8, label %14, !dbg !64

; <label>:8                                       ; preds = %0
  %9 = load i32* @NTSSig, !dbg !64
  %10 = icmp ne i32 1, %9, !dbg !64
  br i1 %10, label %11, label %12

; <label>:11                                      ; preds = %8
  call void @find_err()
  unreachable

; <label>:12                                      ; preds = %8
  store i32 0, i32* @NTSSig, !dbg !64
  %13 = load i32* @SPSSig, !dbg !64
  store i32 27, i32* @SPSSig, !dbg !64
  br label %32, !dbg !64

; <label>:14                                      ; preds = %0
  %15 = load i32* @NTSSig, !dbg !66
  %16 = icmp ne i32 1, %15, !dbg !66
  br i1 %16, label %17, label %18

; <label>:17                                      ; preds = %14
  call void @find_err()
  unreachable

; <label>:18                                      ; preds = %14
  store i32 0, i32* @NTSSig, !dbg !66
  call void @llvm.dbg.declare(metadata !{i32* %j}, metadata !67), !dbg !66
  %19 = load i32** %2, align 8, !dbg !66
  %20 = load i32* %3, align 4, !dbg !66
  %21 = load i32* %4, align 4, !dbg !66
  %22 = call i32 @partition(i32* %19, i32 %20, i32 %21), !dbg !66
  store i32 %22, i32* %j, align 4, !dbg !66
  %23 = load i32** %2, align 8, !dbg !68
  %24 = load i32* %3, align 4, !dbg !68
  %25 = load i32* %j, align 4, !dbg !68
  %26 = sub nsw i32 %25, 1, !dbg !68
  call void @sort(i32* %23, i32 %24, i32 %26), !dbg !68
  %27 = load i32** %2, align 8, !dbg !69
  %28 = load i32* %j, align 4, !dbg !69
  %29 = add nsw i32 %28, 1, !dbg !69
  %30 = load i32* %4, align 4, !dbg !69
  call void @sort(i32* %27, i32 %29, i32 %30), !dbg !69
  %31 = load i32* @SPSSig, !dbg !70
  store i32 27, i32* @SPSSig, !dbg !70
  br label %32, !dbg !70

; <label>:32                                      ; preds = %18, %12
  %33 = load i32* @NTSSig, !dbg !70
  %34 = icmp ne i32 0, %33, !dbg !70
  br i1 %34, label %35, label %36

; <label>:35                                      ; preds = %32
  call void @find_err()
  unreachable

; <label>:36                                      ; preds = %32
  store i32 1, i32* @NTSSig, !dbg !70
  ret void, !dbg !70
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = load i32* @NTSSig
  store i32 0, i32* @NTSSig
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8**, align 8
  %a = alloca [12 x i32], align 16
  %i = alloca i32, align 4
  store i32 0, i32* %2
  store i32 %argc, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !71), !dbg !72
  store i8** %argv, i8*** %4, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %4}, metadata !73), !dbg !72
  call void @llvm.dbg.declare(metadata !{[12 x i32]* %a}, metadata !74), !dbg !78
  %5 = bitcast [12 x i32]* %a to i8*, !dbg !78
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %5, i8* bitcast ([12 x i32]* @main.a to i8*), i64 48, i32 16, i1 false), !dbg !78
  %6 = getelementptr inbounds [12 x i32]* %a, i32 0, i32 0, !dbg !79
  call void @sort(i32* %6, i32 0, i32 11), !dbg !79
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !80), !dbg !81
  store i32 0, i32* %i, align 4, !dbg !82
  %7 = load i32* @SPSSig, !dbg !82
  store i32 29, i32* @SPSSig, !dbg !82
  br label %8, !dbg !82

; <label>:8                                       ; preds = %29, %0
  %9 = load i32* @NTSSig, !dbg !82
  %10 = icmp ne i32 0, %9, !dbg !82
  br i1 %10, label %11, label %12

; <label>:11                                      ; preds = %8
  call void @find_err()
  unreachable

; <label>:12                                      ; preds = %8
  store i32 1, i32* @NTSSig, !dbg !82
  %13 = load i32* %i, align 4, !dbg !82
  %14 = icmp slt i32 %13, 12, !dbg !82
  br i1 %14, label %15, label %32, !dbg !82

; <label>:15                                      ; preds = %12
  %16 = load i32* @NTSSig, !dbg !84
  %17 = icmp ne i32 1, %16, !dbg !84
  br i1 %17, label %18, label %19

; <label>:18                                      ; preds = %15
  call void @find_err()
  unreachable

; <label>:19                                      ; preds = %15
  store i32 0, i32* @NTSSig, !dbg !84
  %20 = load i32* %i, align 4, !dbg !84
  %21 = sext i32 %20 to i64, !dbg !84
  %22 = getelementptr inbounds [12 x i32]* %a, i32 0, i64 %21, !dbg !84
  %23 = load i32* %22, align 4, !dbg !84
  %24 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @.str1, i32 0, i32 0), i32 %23), !dbg !84
  br label %25, !dbg !86

; <label>:25                                      ; preds = %19
  %26 = load i32* @SPSSig, !dbg !82
  %27 = icmp ne i32 29, %26, !dbg !82
  br i1 %27, label %28, label %29

; <label>:28                                      ; preds = %25
  call void @find_err()
  unreachable

; <label>:29                                      ; preds = %25
  %30 = load i32* %i, align 4, !dbg !82
  %31 = add nsw i32 %30, 1, !dbg !82
  store i32 %31, i32* %i, align 4, !dbg !82
  store i32 29, i32* @SPSSig, !dbg !82
  br label %8, !dbg !82

; <label>:32                                      ; preds = %12
  %33 = load i32* @NTSSig, !dbg !87
  %34 = icmp ne i32 1, %33, !dbg !87
  br i1 %34, label %35, label %36

; <label>:35                                      ; preds = %32
  call void @find_err()
  unreachable

; <label>:36                                      ; preds = %32
  store i32 0, i32* @NTSSig, !dbg !87
  %37 = load i32* @SPSSig, !dbg !87
  %38 = icmp ne i32 29, %37, !dbg !87
  br i1 %38, label %39, label %40

; <label>:39                                      ; preds = %36
  call void @find_err()
  unreachable

; <label>:40                                      ; preds = %36
  %41 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str2, i32 0, i32 0)), !dbg !87
  store i32 29, i32* @SPSSig, !dbg !88
  ret i32 0, !dbg !88
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #3

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!23, !24}
!llvm.ident = !{!25}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (tags/RELEASE_34/final)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/hu/llvm-3.4/test/qsort_small.c] [DW_LANG_C99]
!1 = metadata !{metadata !"qsort_small.c", metadata !"/home/hu/llvm-3.4/test"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !10, metadata !13, metadata !16, metadata !17}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"exc", metadata !"exc", metadata !"", i32 4, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32, i32)* @exc, null, null, metadata !2, i32 4} ; [ DW_TAG_subprogram ] [line 4] [def] [exc]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/hu/llvm-3.4/test/qsort_small.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null, metadata !8, metadata !9, metadata !9}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!9 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!10 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"partition", metadata !"partition", metadata !"", i32 9, metadata !11, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32*, i32, i32)* @partition, null, null, metadata !2, i32 9} ; [ DW_TAG_subprogram ] [line 9] [def] [partition]
!11 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !12, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!12 = metadata !{metadata !9, metadata !8, metadata !9, metadata !9}
!13 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"find_err", metadata !"find_err", metadata !"", i32 21, metadata !14, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @find_err, null, null, metadata !2, i32 22} ; [ DW_TAG_subprogram ] [line 21] [def] [scope 22] [find_err]
!14 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !15, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!15 = metadata !{null}
!16 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"sort", metadata !"sort", metadata !"", i32 25, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32, i32)* @sort, null, null, metadata !2, i32 25} ; [ DW_TAG_subprogram ] [line 25] [def] [sort]
!17 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 32, metadata !18, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 32} ; [ DW_TAG_subprogram ] [line 32] [def] [main]
!18 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !19, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!19 = metadata !{metadata !9, metadata !9, metadata !20}
!20 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !21} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!21 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !22} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!22 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!23 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!24 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!25 = metadata !{metadata !"clang version 3.4 (tags/RELEASE_34/final)"}
!26 = metadata !{i32 786689, metadata !4, metadata !"a", metadata !5, i32 16777220, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [a] [line 4]
!27 = metadata !{i32 4, i32 0, metadata !4, null}
!28 = metadata !{i32 786689, metadata !4, metadata !"i", metadata !5, i32 33554436, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [i] [line 4]
!29 = metadata !{i32 786689, metadata !4, metadata !"j", metadata !5, i32 50331652, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [j] [line 4]
!30 = metadata !{i32 786688, metadata !4, metadata !"temp", metadata !5, i32 5, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [temp] [line 5]
!31 = metadata !{i32 5, i32 0, metadata !4, null}
!32 = metadata !{i32 6, i32 0, metadata !4, null}
!33 = metadata !{i32 7, i32 0, metadata !4, null}
!34 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!35 = metadata !{i32 786689, metadata !10, metadata !"a", metadata !5, i32 16777225, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [a] [line 9]
!36 = metadata !{i32 9, i32 0, metadata !10, null}
!37 = metadata !{i32 786689, metadata !10, metadata !"lo", metadata !5, i32 33554441, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [lo] [line 9]
!38 = metadata !{i32 786689, metadata !10, metadata !"hi", metadata !5, i32 50331657, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [hi] [line 9]
!39 = metadata !{i32 786688, metadata !10, metadata !"i", metadata !5, i32 10, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 10]
!40 = metadata !{i32 10, i32 0, metadata !10, null}
!41 = metadata !{i32 786688, metadata !10, metadata !"j", metadata !5, i32 10, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [j] [line 10]
!42 = metadata !{i32 786688, metadata !10, metadata !"v", metadata !5, i32 11, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [v] [line 11]
!43 = metadata !{i32 11, i32 0, metadata !10, null}
!44 = metadata !{i32 12, i32 0, metadata !10, null}
!45 = metadata !{i32 13, i32 0, metadata !46, null}
!46 = metadata !{i32 786443, metadata !1, metadata !10, i32 12, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!47 = metadata !{i32 13, i32 0, metadata !48, null}
!48 = metadata !{i32 786443, metadata !1, metadata !46, i32 13, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!49 = metadata !{i32 14, i32 0, metadata !46, null}
!50 = metadata !{i32 14, i32 0, metadata !51, null}
!51 = metadata !{i32 786443, metadata !1, metadata !46, i32 14, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!52 = metadata !{i32 15, i32 0, metadata !53, null}
!53 = metadata !{i32 786443, metadata !1, metadata !46, i32 15, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!54 = metadata !{i32 16, i32 0, metadata !46, null}
!55 = metadata !{i32 17, i32 0, metadata !46, null}
!56 = metadata !{i32 18, i32 0, metadata !10, null}
!57 = metadata !{i32 19, i32 0, metadata !10, null}
!58 = metadata !{i32 23, i32 0, metadata !13, null}
!59 = metadata !{i32 24, i32 0, metadata !13, null}
!60 = metadata !{i32 786689, metadata !16, metadata !"a", metadata !5, i32 16777241, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [a] [line 25]
!61 = metadata !{i32 25, i32 0, metadata !16, null}
!62 = metadata !{i32 786689, metadata !16, metadata !"lo", metadata !5, i32 33554457, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [lo] [line 25]
!63 = metadata !{i32 786689, metadata !16, metadata !"hi", metadata !5, i32 50331673, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [hi] [line 25]
!64 = metadata !{i32 26, i32 0, metadata !65, null}
!65 = metadata !{i32 786443, metadata !1, metadata !16, i32 26, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!66 = metadata !{i32 27, i32 0, metadata !16, null}
!67 = metadata !{i32 786688, metadata !16, metadata !"j", metadata !5, i32 27, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [j] [line 27]
!68 = metadata !{i32 28, i32 0, metadata !16, null}
!69 = metadata !{i32 29, i32 0, metadata !16, null}
!70 = metadata !{i32 30, i32 0, metadata !16, null}
!71 = metadata !{i32 786689, metadata !17, metadata !"argc", metadata !5, i32 16777248, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argc] [line 32]
!72 = metadata !{i32 32, i32 0, metadata !17, null}
!73 = metadata !{i32 786689, metadata !17, metadata !"argv", metadata !5, i32 33554464, metadata !20, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argv] [line 32]
!74 = metadata !{i32 786688, metadata !17, metadata !"a", metadata !5, i32 33, metadata !75, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [a] [line 33]
!75 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 384, i64 32, i32 0, i32 0, metadata !9, metadata !76, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 384, align 32, offset 0] [from int]
!76 = metadata !{metadata !77}
!77 = metadata !{i32 786465, i64 0, i64 12}       ; [ DW_TAG_subrange_type ] [0, 11]
!78 = metadata !{i32 33, i32 0, metadata !17, null}
!79 = metadata !{i32 34, i32 0, metadata !17, null}
!80 = metadata !{i32 786688, metadata !17, metadata !"i", metadata !5, i32 35, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 35]
!81 = metadata !{i32 35, i32 0, metadata !17, null}
!82 = metadata !{i32 36, i32 0, metadata !83, null}
!83 = metadata !{i32 786443, metadata !1, metadata !17, i32 36, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!84 = metadata !{i32 37, i32 0, metadata !85, null}
!85 = metadata !{i32 786443, metadata !1, metadata !83, i32 36, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/hu/llvm-3.4/test/qsort_small.c]
!86 = metadata !{i32 38, i32 0, metadata !85, null}
!87 = metadata !{i32 39, i32 0, metadata !17, null}
!88 = metadata !{i32 40, i32 0, metadata !17, null}

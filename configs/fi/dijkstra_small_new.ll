; ModuleID = 'dijkstra_small_new.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._QITEM = type { i32, i32, i32, %struct._QITEM* }
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct._NODE = type { i32, i32 }

@qHead = global %struct._QITEM* null, align 8
@g_qCount = global i32 0, align 4
@.str = private unnamed_addr constant [21 x i8] c"find data flow error\00", align 1
@.str1 = private unnamed_addr constant [4 x i8] c" %d\00", align 1
@stdout = external global %struct._IO_FILE*
@stderr = external global %struct._IO_FILE*
@.str2 = private unnamed_addr constant [16 x i8] c"Out of memory.\0A\00", align 1
@ch = common global i32 0, align 4
@rgnNodes = common global [100 x %struct._NODE] zeroinitializer, align 16
@.str3 = private unnamed_addr constant [54 x i8] c"Shortest path is 0 in cost. Just stay where you are.\0A\00", align 1
@iNode = common global i32 0, align 4
@iDist = common global i32 0, align 4
@iPrev = common global i32 0, align 4
@i = common global i32 0, align 4
@AdjMatrix = common global [100 x [100 x i32]] zeroinitializer, align 16
@iCost = common global i32 0, align 4
@.str4 = private unnamed_addr constant [30 x i8] c"Shortest path is %d in cost. \00", align 1
@.str5 = private unnamed_addr constant [10 x i8] c"Path is: \00", align 1
@.str6 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str7 = private unnamed_addr constant [12 x i8] c"./input.dat\00", align 1
@.str8 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str9 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: nounwind uwtable
define void @checker_cmp(i1 zeroext %i) #0 {
  %1 = alloca i8, align 1
  %2 = zext i1 %i to i8
  store i8 %2, i8* %1, align 1

  %3 = load i8* %1, align 1, !dbg !68
  %4 = trunc i8 %3 to i1, !dbg !68
  br i1 %4, label %7, label %5, !dbg !68

; <label>:5                                       ; preds = %0
  %6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([21 x i8]* @.str, i32 0, i32 0)), !dbg !70
  call void @exit(i32 -1) #4, !dbg !72
  unreachable, !dbg !72

; <label>:7                                       ; preds = %0
  ret void, !dbg !73
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: noreturn
declare void @exit(i32) #3

; Function Attrs: nounwind uwtable
define void @print_path(%struct._NODE* %rgnNodes, i32 %chNode) #0 {
  %1 = alloca %struct._NODE*, align 8
  %2 = alloca i32, align 4
  store %struct._NODE* %rgnNodes, %struct._NODE** %1, align 8
  call void @llvm.dbg.declare(metadata !{%struct._NODE** %1}, metadata !74), !dbg !75
  store i32 %chNode, i32* %2, align 4
  call void @llvm.dbg.declare(metadata !{i32* %2}, metadata !76), !dbg !75
  %3 = load i32* %2, align 4, !dbg !77
  %4 = sext i32 %3 to i64, !dbg !77
  %5 = load %struct._NODE** %1, align 8, !dbg !77
  %6 = getelementptr inbounds %struct._NODE* %5, i64 %4, !dbg !77
  %7 = getelementptr inbounds %struct._NODE* %6, i32 0, i32 1, !dbg !77
  %8 = load i32* %7, align 4, !dbg !77
  %9 = icmp ne i32 %8, 9999, !dbg !77
  br i1 %9, label %10, label %18, !dbg !77

; <label>:10                                      ; preds = %0
  %11 = load %struct._NODE** %1, align 8, !dbg !79
  %12 = load i32* %2, align 4, !dbg !79
  %13 = sext i32 %12 to i64, !dbg !79
  %14 = load %struct._NODE** %1, align 8, !dbg !79
  %15 = getelementptr inbounds %struct._NODE* %14, i64 %13, !dbg !79
  %16 = getelementptr inbounds %struct._NODE* %15, i32 0, i32 1, !dbg !79
  %17 = load i32* %16, align 4, !dbg !79
  call void @print_path(%struct._NODE* %11, i32 %17), !dbg !79
  br label %18, !dbg !81

; <label>:18                                      ; preds = %10, %0
  %19 = load i32* %2, align 4, !dbg !82
  %20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str1, i32 0, i32 0), i32 %19), !dbg !82
  %21 = load %struct._IO_FILE** @stdout, align 8, !dbg !83
  %22 = call i32 @fflush(%struct._IO_FILE* %21), !dbg !83
  ret void, !dbg !84
}

declare i32 @fflush(%struct._IO_FILE*) #2

; Function Attrs: nounwind uwtable
define void @enqueue(i32 %iNode, i32 %iDist, i32 %iPrev) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %qNew = alloca %struct._QITEM*, align 8
  %qLast = alloca %struct._QITEM*, align 8
  store i32 %iNode, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !85), !dbg !86
  store i32 %iDist, i32* %2, align 4
  call void @llvm.dbg.declare(metadata !{i32* %2}, metadata !87), !dbg !86
  store i32 %iPrev, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !88), !dbg !86
  call void @llvm.dbg.declare(metadata !{%struct._QITEM** %qNew}, metadata !89), !dbg !90
  %4 = call i8* @malloc(i64 24), !dbg !90
  %5 = bitcast i8* %4 to %struct._QITEM*, !dbg !90
  store %struct._QITEM* %5, %struct._QITEM** %qNew, align 8, !dbg !90
  call void @llvm.dbg.declare(metadata !{%struct._QITEM** %qLast}, metadata !91), !dbg !92
  %6 = load %struct._QITEM** @qHead, align 8, !dbg !92
  store %struct._QITEM* %6, %struct._QITEM** %qLast, align 8, !dbg !92
  %7 = load %struct._QITEM** %qNew, align 8, !dbg !93
  %8 = icmp ne %struct._QITEM* %7, null, !dbg !93
  br i1 %8, label %12, label %9, !dbg !93

; <label>:9                                       ; preds = %0
  %10 = load %struct._IO_FILE** @stderr, align 8, !dbg !95
  %11 = call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([16 x i8]* @.str2, i32 0, i32 0)), !dbg !95
  call void @exit(i32 1) #4, !dbg !97
  unreachable, !dbg !97

; <label>:12                                      ; preds = %0
  %13 = load i32* %1, align 4, !dbg !98
  %14 = load %struct._QITEM** %qNew, align 8, !dbg !98
  %15 = getelementptr inbounds %struct._QITEM* %14, i32 0, i32 0, !dbg !98
  store i32 %13, i32* %15, align 4, !dbg !98
  %16 = load i32* %2, align 4, !dbg !99
  %17 = load %struct._QITEM** %qNew, align 8, !dbg !99
  %18 = getelementptr inbounds %struct._QITEM* %17, i32 0, i32 1, !dbg !99
  store i32 %16, i32* %18, align 4, !dbg !99
  %19 = load i32* %3, align 4, !dbg !100
  %20 = load %struct._QITEM** %qNew, align 8, !dbg !100
  %21 = getelementptr inbounds %struct._QITEM* %20, i32 0, i32 2, !dbg !100
  store i32 %19, i32* %21, align 4, !dbg !100
  %22 = load %struct._QITEM** %qNew, align 8, !dbg !101
  %23 = getelementptr inbounds %struct._QITEM* %22, i32 0, i32 3, !dbg !101
  store %struct._QITEM* null, %struct._QITEM** %23, align 8, !dbg !101
  %24 = load %struct._QITEM** %qLast, align 8, !dbg !102
  %25 = icmp ne %struct._QITEM* %24, null, !dbg !102
  br i1 %25, label %28, label %26, !dbg !102

; <label>:26                                      ; preds = %12
  %27 = load %struct._QITEM** %qNew, align 8, !dbg !104
  store %struct._QITEM* %27, %struct._QITEM** @qHead, align 8, !dbg !104
  br label %42, !dbg !106

; <label>:28                                      ; preds = %12
  br label %29, !dbg !107

; <label>:29                                      ; preds = %34, %28
  %30 = load %struct._QITEM** %qLast, align 8, !dbg !107
  %31 = getelementptr inbounds %struct._QITEM* %30, i32 0, i32 3, !dbg !107
  %32 = load %struct._QITEM** %31, align 8, !dbg !107
  %33 = icmp ne %struct._QITEM* %32, null, !dbg !107
  br i1 %33, label %34, label %38, !dbg !107

; <label>:34                                      ; preds = %29
  %35 = load %struct._QITEM** %qLast, align 8, !dbg !107
  %36 = getelementptr inbounds %struct._QITEM* %35, i32 0, i32 3, !dbg !107
  %37 = load %struct._QITEM** %36, align 8, !dbg !107
  store %struct._QITEM* %37, %struct._QITEM** %qLast, align 8, !dbg !107
  br label %29, !dbg !107

; <label>:38                                      ; preds = %29
  %39 = load %struct._QITEM** %qNew, align 8, !dbg !109
  %40 = load %struct._QITEM** %qLast, align 8, !dbg !109
  %41 = getelementptr inbounds %struct._QITEM* %40, i32 0, i32 3, !dbg !109
  store %struct._QITEM* %39, %struct._QITEM** %41, align 8, !dbg !109
  br label %42

; <label>:42                                      ; preds = %38, %26
  %43 = load i32* @g_qCount, align 4, !dbg !110
  %44 = add nsw i32 %43, 1, !dbg !110
  store i32 %44, i32* @g_qCount, align 4, !dbg !110
  ret void, !dbg !111
}

declare i8* @malloc(i64) #2

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: nounwind uwtable
define void @dequeue(i32* %piNode, i32* %piDist, i32* %piPrev) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %qKill = alloca %struct._QITEM*, align 8
  store i32* %piNode, i32** %1, align 8
  call void @llvm.dbg.declare(metadata !{i32** %1}, metadata !112), !dbg !113
  store i32* %piDist, i32** %2, align 8
  call void @llvm.dbg.declare(metadata !{i32** %2}, metadata !114), !dbg !113
  store i32* %piPrev, i32** %3, align 8
  call void @llvm.dbg.declare(metadata !{i32** %3}, metadata !115), !dbg !113
  call void @llvm.dbg.declare(metadata !{%struct._QITEM** %qKill}, metadata !116), !dbg !117
  %4 = load %struct._QITEM** @qHead, align 8, !dbg !117
  store %struct._QITEM* %4, %struct._QITEM** %qKill, align 8, !dbg !117
  %5 = load %struct._QITEM** @qHead, align 8, !dbg !118
  %6 = icmp ne %struct._QITEM* %5, null, !dbg !118
  br i1 %6, label %7, label %27, !dbg !118

; <label>:7                                       ; preds = %0
  %8 = load %struct._QITEM** @qHead, align 8, !dbg !120
  %9 = getelementptr inbounds %struct._QITEM* %8, i32 0, i32 0, !dbg !120
  %10 = load i32* %9, align 4, !dbg !120
  %11 = load i32** %1, align 8, !dbg !120
  store i32 %10, i32* %11, align 4, !dbg !120
  %12 = load %struct._QITEM** @qHead, align 8, !dbg !122
  %13 = getelementptr inbounds %struct._QITEM* %12, i32 0, i32 1, !dbg !122
  %14 = load i32* %13, align 4, !dbg !122
  %15 = load i32** %2, align 8, !dbg !122
  store i32 %14, i32* %15, align 4, !dbg !122
  %16 = load %struct._QITEM** @qHead, align 8, !dbg !123
  %17 = getelementptr inbounds %struct._QITEM* %16, i32 0, i32 2, !dbg !123
  %18 = load i32* %17, align 4, !dbg !123
  %19 = load i32** %3, align 8, !dbg !123
  store i32 %18, i32* %19, align 4, !dbg !123
  %20 = load %struct._QITEM** @qHead, align 8, !dbg !124
  %21 = getelementptr inbounds %struct._QITEM* %20, i32 0, i32 3, !dbg !124
  %22 = load %struct._QITEM** %21, align 8, !dbg !124
  store %struct._QITEM* %22, %struct._QITEM** @qHead, align 8, !dbg !124
  %23 = load %struct._QITEM** %qKill, align 8, !dbg !125
  %24 = call i32 (%struct._QITEM*, ...)* bitcast (i32 (...)* @free to i32 (%struct._QITEM*, ...)*)(%struct._QITEM* %23), !dbg !125
  %25 = load i32* @g_qCount, align 4, !dbg !126
  %26 = add nsw i32 %25, -1, !dbg !126
  store i32 %26, i32* @g_qCount, align 4, !dbg !126
  br label %27, !dbg !127

; <label>:27                                      ; preds = %7, %0
  ret void, !dbg !128
}

declare i32 @free(...) #2

; Function Attrs: nounwind uwtable
define i32 @qcount() #0 {
  %1 = load i32* @g_qCount, align 4, !dbg !129
  ret i32 %1, !dbg !129
}

; Function Attrs: nounwind uwtable
define i32 @dijkstra(i32 %chStart, i32 %chEnd) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %chStart, i32* %2, align 4
  call void @llvm.dbg.declare(metadata !{i32* %2}, metadata !130), !dbg !131
  store i32 %chEnd, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !132), !dbg !131
  store i32 0, i32* @ch, align 4, !dbg !133
  br label %4, !dbg !133

; <label>:4                                       ; preds = %16, %0
  %5 = load i32* @ch, align 4, !dbg !133
  %6 = icmp slt i32 %5, 100, !dbg !133
  br i1 %6, label %7, label %19, !dbg !133

; <label>:7                                       ; preds = %4
  %8 = load i32* @ch, align 4, !dbg !135
  %9 = sext i32 %8 to i64, !dbg !135
  %10 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %9, !dbg !135
  %11 = getelementptr inbounds %struct._NODE* %10, i32 0, i32 0, !dbg !135
  store i32 9999, i32* %11, align 4, !dbg !135
  %12 = load i32* @ch, align 4, !dbg !137
  %13 = sext i32 %12 to i64, !dbg !137
  %14 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %13, !dbg !137
  %15 = getelementptr inbounds %struct._NODE* %14, i32 0, i32 1, !dbg !137
  store i32 9999, i32* %15, align 4, !dbg !137
  br label %16, !dbg !138

; <label>:16                                      ; preds = %7
  %17 = load i32* @ch, align 4, !dbg !133
  %18 = add nsw i32 %17, 1, !dbg !133
  store i32 %18, i32* @ch, align 4, !dbg !133
  br label %4, !dbg !133

; <label>:19                                      ; preds = %4
  %20 = load i32* %2, align 4, !dbg !139
  %21 = load i32* %3, align 4, !dbg !139
  %22 = icmp eq i32 %20, %21, !dbg !139
  br i1 %22, label %23, label %25, !dbg !139

; <label>:23                                      ; preds = %19
  %24 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([54 x i8]* @.str3, i32 0, i32 0)), !dbg !141
  br label %102, !dbg !143

; <label>:25                                      ; preds = %19
  %26 = load i32* %2, align 4, !dbg !144
  %27 = sext i32 %26 to i64, !dbg !144
  %28 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %27, !dbg !144
  %29 = getelementptr inbounds %struct._NODE* %28, i32 0, i32 0, !dbg !144
  store i32 0, i32* %29, align 4, !dbg !144
  %30 = load i32* %2, align 4, !dbg !146
  %31 = sext i32 %30 to i64, !dbg !146
  %32 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %31, !dbg !146
  %33 = getelementptr inbounds %struct._NODE* %32, i32 0, i32 1, !dbg !146
  store i32 9999, i32* %33, align 4, !dbg !146
  %34 = load i32* %2, align 4, !dbg !147
  call void @enqueue(i32 %34, i32 0, i32 9999), !dbg !147
  br label %35, !dbg !148

; <label>:35                                      ; preds = %91, %25
  %36 = call i32 @qcount(), !dbg !148
  %37 = icmp sgt i32 %36, 0, !dbg !148
  br i1 %37, label %38, label %92, !dbg !148

; <label>:38                                      ; preds = %35
  call void @dequeue(i32* @iNode, i32* @iDist, i32* @iPrev), !dbg !149
  store i32 0, i32* @i, align 4, !dbg !151
  br label %39, !dbg !151

; <label>:39                                      ; preds = %88, %38
  %40 = load i32* @i, align 4, !dbg !151
  %41 = icmp slt i32 %40, 100, !dbg !151
  br i1 %41, label %42, label %91, !dbg !151

; <label>:42                                      ; preds = %39
  %43 = load i32* @i, align 4, !dbg !153
  %44 = sext i32 %43 to i64, !dbg !153
  %45 = load i32* @iNode, align 4, !dbg !153
  %46 = sext i32 %45 to i64, !dbg !153
  %47 = getelementptr inbounds [100 x [100 x i32]]* @AdjMatrix, i32 0, i64 %46, !dbg !153
  %48 = getelementptr inbounds [100 x i32]* %47, i32 0, i64 %44, !dbg !153
  %49 = load i32* %48, align 4, !dbg !153
  store i32 %49, i32* @iCost, align 4, !dbg !153
  %50 = icmp ne i32 %49, 9999, !dbg !153
  br i1 %50, label %51, label %87, !dbg !153

; <label>:51                                      ; preds = %42
  %52 = load i32* @i, align 4, !dbg !156
  %53 = sext i32 %52 to i64, !dbg !156
  %54 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %53, !dbg !156
  %55 = getelementptr inbounds %struct._NODE* %54, i32 0, i32 0, !dbg !156
  %56 = load i32* %55, align 4, !dbg !156
  %57 = icmp eq i32 9999, %56, !dbg !156
  br i1 %57, label %68, label %58, !dbg !156

; <label>:58                                      ; preds = %51
  %59 = load i32* @i, align 4, !dbg !156
  %60 = sext i32 %59 to i64, !dbg !156
  %61 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %60, !dbg !156
  %62 = getelementptr inbounds %struct._NODE* %61, i32 0, i32 0, !dbg !156
  %63 = load i32* %62, align 4, !dbg !156
  %64 = load i32* @iCost, align 4, !dbg !156
  %65 = load i32* @iDist, align 4, !dbg !156
  %66 = add nsw i32 %64, %65, !dbg !156
  %67 = icmp sgt i32 %63, %66, !dbg !156
  br i1 %67, label %68, label %86, !dbg !156

; <label>:68                                      ; preds = %58, %51
  %69 = load i32* @iDist, align 4, !dbg !159
  %70 = load i32* @iCost, align 4, !dbg !159
  %71 = add nsw i32 %69, %70, !dbg !159
  %72 = load i32* @i, align 4, !dbg !159
  %73 = sext i32 %72 to i64, !dbg !159
  %74 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %73, !dbg !159
  %75 = getelementptr inbounds %struct._NODE* %74, i32 0, i32 0, !dbg !159
  store i32 %71, i32* %75, align 4, !dbg !159
  %76 = load i32* @iNode, align 4, !dbg !161
  %77 = load i32* @i, align 4, !dbg !161
  %78 = sext i32 %77 to i64, !dbg !161
  %79 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %78, !dbg !161
  %80 = getelementptr inbounds %struct._NODE* %79, i32 0, i32 1, !dbg !161
  store i32 %76, i32* %80, align 4, !dbg !161
  %81 = load i32* @i, align 4, !dbg !162
  %82 = load i32* @iDist, align 4, !dbg !162
  %83 = load i32* @iCost, align 4, !dbg !162
  %84 = add nsw i32 %82, %83, !dbg !162
  %85 = load i32* @iNode, align 4, !dbg !162
  call void @enqueue(i32 %81, i32 %84, i32 %85), !dbg !162
  br label %86, !dbg !163

; <label>:86                                      ; preds = %68, %58
  br label %87, !dbg !164

; <label>:87                                      ; preds = %86, %42
  br label %88, !dbg !165

; <label>:88                                      ; preds = %87
  %89 = load i32* @i, align 4, !dbg !151
  %90 = add nsw i32 %89, 1, !dbg !151
  store i32 %90, i32* @i, align 4, !dbg !151
  br label %39, !dbg !151

; <label>:91                                      ; preds = %39
  br label %35, !dbg !166

; <label>:92                                      ; preds = %35
  %93 = load i32* %3, align 4, !dbg !167
  %94 = sext i32 %93 to i64, !dbg !167
  %95 = getelementptr inbounds [100 x %struct._NODE]* @rgnNodes, i32 0, i64 %94, !dbg !167
  %96 = getelementptr inbounds %struct._NODE* %95, i32 0, i32 0, !dbg !167
  %97 = load i32* %96, align 4, !dbg !167
  %98 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([30 x i8]* @.str4, i32 0, i32 0), i32 %97), !dbg !167
  %99 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.str5, i32 0, i32 0)), !dbg !168
  %100 = load i32* %3, align 4, !dbg !169
  call void @print_path(%struct._NODE* getelementptr inbounds ([100 x %struct._NODE]* @rgnNodes, i32 0, i32 0), i32 %100), !dbg !169
  %101 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str6, i32 0, i32 0)), !dbg !170
  br label %102

; <label>:102                                     ; preds = %92, %23
  %103 = load i32* %1, !dbg !171
  ret i32 %103, !dbg !171
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %fp = alloca %struct._IO_FILE*, align 8
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  call void @llvm.dbg.declare(metadata !{i32* %2}, metadata !172), !dbg !173
  store i8** %argv, i8*** %3, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %3}, metadata !174), !dbg !173
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !175), !dbg !176
  call void @llvm.dbg.declare(metadata !{i32* %j}, metadata !177), !dbg !176
  call void @llvm.dbg.declare(metadata !{i32* %k}, metadata !178), !dbg !176
  call void @llvm.dbg.declare(metadata !{%struct._IO_FILE** %fp}, metadata !179), !dbg !235
  %4 = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([12 x i8]* @.str7, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.str8, i32 0, i32 0)), !dbg !236
  store %struct._IO_FILE* %4, %struct._IO_FILE** %fp, align 8, !dbg !236
  store i32 0, i32* %i, align 4, !dbg !237
  br label %5, !dbg !237

; <label>:5                                       ; preds = %26, %0
  %6 = load i32* %i, align 4, !dbg !237
  %7 = icmp slt i32 %6, 100, !dbg !237
  br i1 %7, label %8, label %29, !dbg !237

; <label>:8                                       ; preds = %5
  store i32 0, i32* %j, align 4, !dbg !239
  br label %9, !dbg !239

; <label>:9                                       ; preds = %22, %8
  %10 = load i32* %j, align 4, !dbg !239
  %11 = icmp slt i32 %10, 100, !dbg !239
  br i1 %11, label %12, label %25, !dbg !239

; <label>:12                                      ; preds = %9
  %13 = load %struct._IO_FILE** %fp, align 8, !dbg !242
  %14 = call i32 (%struct._IO_FILE*, i8*, ...)* @__isoc99_fscanf(%struct._IO_FILE* %13, i8* getelementptr inbounds ([3 x i8]* @.str9, i32 0, i32 0), i32* %k), !dbg !242
  %15 = load i32* %k, align 4, !dbg !244
  %16 = load i32* %j, align 4, !dbg !244
  %17 = sext i32 %16 to i64, !dbg !244
  %18 = load i32* %i, align 4, !dbg !244
  %19 = sext i32 %18 to i64, !dbg !244
  %20 = getelementptr inbounds [100 x [100 x i32]]* @AdjMatrix, i32 0, i64 %19, !dbg !244
  %21 = getelementptr inbounds [100 x i32]* %20, i32 0, i64 %17, !dbg !244
  store i32 %15, i32* %21, align 4, !dbg !244
  br label %22, !dbg !245

; <label>:22                                      ; preds = %12
  %23 = load i32* %j, align 4, !dbg !239
  %24 = add nsw i32 %23, 1, !dbg !239
  store i32 %24, i32* %j, align 4, !dbg !239
  br label %9, !dbg !239

; <label>:25                                      ; preds = %9
  br label %26, !dbg !246

; <label>:26                                      ; preds = %25
  %27 = load i32* %i, align 4, !dbg !237
  %28 = add nsw i32 %27, 1, !dbg !237
  store i32 %28, i32* %i, align 4, !dbg !237
  br label %5, !dbg !237

; <label>:29                                      ; preds = %5
  store i32 0, i32* %i, align 4, !dbg !247
  store i32 50, i32* %j, align 4, !dbg !247
  br label %30, !dbg !247

; <label>:30                                      ; preds = %39, %29
  %31 = load i32* %i, align 4, !dbg !247
  %32 = icmp slt i32 %31, 20, !dbg !247
  br i1 %32, label %33, label %44, !dbg !247

; <label>:33                                      ; preds = %30
  %34 = load i32* %j, align 4, !dbg !249
  %35 = srem i32 %34, 100, !dbg !249
  store i32 %35, i32* %j, align 4, !dbg !249
  %36 = load i32* %i, align 4, !dbg !251
  %37 = load i32* %j, align 4, !dbg !251
  %38 = call i32 @dijkstra(i32 %36, i32 %37), !dbg !251
  br label %39, !dbg !252

; <label>:39                                      ; preds = %33
  %40 = load i32* %i, align 4, !dbg !247
  %41 = add nsw i32 %40, 1, !dbg !247
  store i32 %41, i32* %i, align 4, !dbg !247
  %42 = load i32* %j, align 4, !dbg !247
  %43 = add nsw i32 %42, 1, !dbg !247
  store i32 %43, i32* %j, align 4, !dbg !247
  br label %30, !dbg !247

; <label>:44                                      ; preds = %30
  call void @exit(i32 0) #4, !dbg !253
  unreachable, !dbg !253
                                                  ; No predecessors!
  %46 = load i32* %1, !dbg !254
  ret i32 %46, !dbg !254
}

declare %struct._IO_FILE* @fopen(i8*, i8*) #2

declare i32 @__isoc99_fscanf(%struct._IO_FILE*, i8*, ...) #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!63, !64}
!llvm.ident = !{!65}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (tags/RELEASE_34/final)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !38, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c] [DW_LANG_C99]
!1 = metadata !{metadata !"dijkstra_small_new.c", metadata !"/home/yan/mibench/network/dijkstra"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9, metadata !19, metadata !22, metadata !26, metadata !29, metadata !32}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"checker_cmp", metadata !"checker_cmp", metadata !"", i32 35, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i1)* @checker_cmp, null, null, metadata !2, i32 35} ; [ DW_TAG_subprogram ] [line 35] [def] [checker_cmp]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null, metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"print_path", metadata !"print_path", metadata !"", i32 42, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (%struct._NODE*, i32)* @print_path, null, null, metadata !2, i32 43} ; [ DW_TAG_subprogram ] [line 42] [def] [scope 43] [print_path]
!10 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{null, metadata !12, metadata !17}
!12 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !13} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from NODE]
!13 = metadata !{i32 786454, metadata !1, null, metadata !"NODE", i32 11, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ] [NODE] [line 11, size 0, align 0, offset 0] [from _NODE]
!14 = metadata !{i32 786451, metadata !1, null, metadata !"_NODE", i32 6, i64 64, i64 32, i32 0, i32 0, null, metadata !15, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [_NODE] [line 6, size 64, align 32, offset 0] [def] [from ]
!15 = metadata !{metadata !16, metadata !18}
!16 = metadata !{i32 786445, metadata !1, metadata !14, metadata !"iDist", i32 8, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_member ] [iDist] [line 8, size 32, align 32, offset 0] [from int]
!17 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!18 = metadata !{i32 786445, metadata !1, metadata !14, metadata !"iPrev", i32 9, i64 32, i64 32, i64 32, i32 0, metadata !17} ; [ DW_TAG_member ] [iPrev] [line 9, size 32, align 32, offset 32] [from int]
!19 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"enqueue", metadata !"enqueue", metadata !"", i32 53, metadata !20, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32, i32, i32)* @enqueue, null, null, metadata !2, i32 54} ; [ DW_TAG_subprogram ] [line 53] [def] [scope 54] [enqueue]
!20 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !21, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!21 = metadata !{null, metadata !17, metadata !17, metadata !17}
!22 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"dequeue", metadata !"dequeue", metadata !"", i32 82, metadata !23, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32*, i32*)* @dequeue, null, null, metadata !2, i32 83} ; [ DW_TAG_subprogram ] [line 82] [def] [scope 83] [dequeue]
!23 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !24, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!24 = metadata !{null, metadata !25, metadata !25, metadata !25}
!25 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!26 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"qcount", metadata !"qcount", metadata !"", i32 99, metadata !27, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 ()* @qcount, null, null, metadata !2, i32 100} ; [ DW_TAG_subprogram ] [line 99] [def] [scope 100] [qcount]
!27 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !28, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!28 = metadata !{metadata !17}
!29 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"dijkstra", metadata !"dijkstra", metadata !"", i32 104, metadata !30, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i32)* @dijkstra, null, null, metadata !2, i32 105} ; [ DW_TAG_subprogram ] [line 104] [def] [scope 105] [dijkstra]
!30 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !31, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!31 = metadata !{metadata !17, metadata !17, metadata !17}
!32 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 151, metadata !33, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 151} ; [ DW_TAG_subprogram ] [line 151] [def] [main]
!33 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !34, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!34 = metadata !{metadata !17, metadata !17, metadata !35}
!35 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !36} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!36 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !37} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!37 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!38 = metadata !{metadata !39, metadata !49, metadata !50, metadata !54, metadata !57, metadata !58, metadata !59, metadata !60, metadata !61, metadata !62}
!39 = metadata !{i32 786484, i32 0, null, metadata !"qHead", metadata !"qHead", metadata !"", metadata !5, i32 22, metadata !40, i32 0, i32 1, %struct._QITEM** @qHead, null} ; [ DW_TAG_variable ] [qHead] [line 22] [def]
!40 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !41} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from QITEM]
!41 = metadata !{i32 786454, metadata !1, null, metadata !"QITEM", i32 20, i64 0, i64 0, i64 0, i32 0, metadata !42} ; [ DW_TAG_typedef ] [QITEM] [line 20, size 0, align 0, offset 0] [from _QITEM]
!42 = metadata !{i32 786451, metadata !1, null, metadata !"_QITEM", i32 13, i64 192, i64 64, i32 0, i32 0, null, metadata !43, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [_QITEM] [line 13, size 192, align 64, offset 0] [def] [from ]
!43 = metadata !{metadata !44, metadata !45, metadata !46, metadata !47}
!44 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"iNode", i32 15, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_member ] [iNode] [line 15, size 32, align 32, offset 0] [from int]
!45 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"iDist", i32 16, i64 32, i64 32, i64 32, i32 0, metadata !17} ; [ DW_TAG_member ] [iDist] [line 16, size 32, align 32, offset 32] [from int]
!46 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"iPrev", i32 17, i64 32, i64 32, i64 64, i32 0, metadata !17} ; [ DW_TAG_member ] [iPrev] [line 17, size 32, align 32, offset 64] [from int]
!47 = metadata !{i32 786445, metadata !1, metadata !42, metadata !"qNext", i32 18, i64 64, i64 64, i64 128, i32 0, metadata !48} ; [ DW_TAG_member ] [qNext] [line 18, size 64, align 64, offset 128] [from ]
!48 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !42} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from _QITEM]
!49 = metadata !{i32 786484, i32 0, null, metadata !"g_qCount", metadata !"g_qCount", metadata !"", metadata !5, i32 29, metadata !17, i32 0, i32 1, i32* @g_qCount, null} ; [ DW_TAG_variable ] [g_qCount] [line 29] [def]
!50 = metadata !{i32 786484, i32 0, null, metadata !"AdjMatrix", metadata !"AdjMatrix", metadata !"", metadata !5, i32 27, metadata !51, i32 0, i32 1, [100 x [100 x i32]]* @AdjMatrix, null} ; [ DW_TAG_variable ] [AdjMatrix] [line 27] [def]
!51 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 320000, i64 32, i32 0, i32 0, metadata !17, metadata !52, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 320000, align 32, offset 0] [from int]
!52 = metadata !{metadata !53, metadata !53}
!53 = metadata !{i32 786465, i64 0, i64 100}      ; [ DW_TAG_subrange_type ] [0, 99]
!54 = metadata !{i32 786484, i32 0, null, metadata !"rgnNodes", metadata !"rgnNodes", metadata !"", metadata !5, i32 30, metadata !55, i32 0, i32 1, [100 x %struct._NODE]* @rgnNodes, null} ; [ DW_TAG_variable ] [rgnNodes] [line 30] [def]
!55 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 6400, i64 32, i32 0, i32 0, metadata !13, metadata !56, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 6400, align 32, offset 0] [from NODE]
!56 = metadata !{metadata !53}
!57 = metadata !{i32 786484, i32 0, null, metadata !"ch", metadata !"ch", metadata !"", metadata !5, i32 31, metadata !17, i32 0, i32 1, i32* @ch, null} ; [ DW_TAG_variable ] [ch] [line 31] [def]
!58 = metadata !{i32 786484, i32 0, null, metadata !"iPrev", metadata !"iPrev", metadata !"", metadata !5, i32 32, metadata !17, i32 0, i32 1, i32* @iPrev, null} ; [ DW_TAG_variable ] [iPrev] [line 32] [def]
!59 = metadata !{i32 786484, i32 0, null, metadata !"iNode", metadata !"iNode", metadata !"", metadata !5, i32 32, metadata !17, i32 0, i32 1, i32* @iNode, null} ; [ DW_TAG_variable ] [iNode] [line 32] [def]
!60 = metadata !{i32 786484, i32 0, null, metadata !"i", metadata !"i", metadata !"", metadata !5, i32 33, metadata !17, i32 0, i32 1, i32* @i, null} ; [ DW_TAG_variable ] [i] [line 33] [def]
!61 = metadata !{i32 786484, i32 0, null, metadata !"iCost", metadata !"iCost", metadata !"", metadata !5, i32 33, metadata !17, i32 0, i32 1, i32* @iCost, null} ; [ DW_TAG_variable ] [iCost] [line 33] [def]
!62 = metadata !{i32 786484, i32 0, null, metadata !"iDist", metadata !"iDist", metadata !"", metadata !5, i32 33, metadata !17, i32 0, i32 1, i32* @iDist, null} ; [ DW_TAG_variable ] [iDist] [line 33] [def]
!63 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!64 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!65 = metadata !{metadata !"clang version 3.4 (tags/RELEASE_34/final)"}
!66 = metadata !{i32 786689, metadata !4, metadata !"i", metadata !5, i32 16777251, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [i] [line 35]
!67 = metadata !{i32 35, i32 0, metadata !4, null}
!68 = metadata !{i32 36, i32 0, metadata !69, null}
!69 = metadata !{i32 786443, metadata !1, metadata !4, i32 36, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!70 = metadata !{i32 37, i32 0, metadata !71, null}
!71 = metadata !{i32 786443, metadata !1, metadata !69, i32 36, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!72 = metadata !{i32 38, i32 0, metadata !71, null}
!73 = metadata !{i32 40, i32 0, metadata !4, null}
!74 = metadata !{i32 786689, metadata !9, metadata !"rgnNodes", metadata !5, i32 16777258, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [rgnNodes] [line 42]
!75 = metadata !{i32 42, i32 0, metadata !9, null}
!76 = metadata !{i32 786689, metadata !9, metadata !"chNode", metadata !5, i32 33554474, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [chNode] [line 42]
!77 = metadata !{i32 44, i32 0, metadata !78, null}
!78 = metadata !{i32 786443, metadata !1, metadata !9, i32 44, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!79 = metadata !{i32 46, i32 0, metadata !80, null}
!80 = metadata !{i32 786443, metadata !1, metadata !78, i32 45, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!81 = metadata !{i32 47, i32 0, metadata !80, null}
!82 = metadata !{i32 48, i32 0, metadata !9, null}
!83 = metadata !{i32 49, i32 0, metadata !9, null}
!84 = metadata !{i32 50, i32 0, metadata !9, null}
!85 = metadata !{i32 786689, metadata !19, metadata !"iNode", metadata !5, i32 16777269, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [iNode] [line 53]
!86 = metadata !{i32 53, i32 0, metadata !19, null}
!87 = metadata !{i32 786689, metadata !19, metadata !"iDist", metadata !5, i32 33554485, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [iDist] [line 53]
!88 = metadata !{i32 786689, metadata !19, metadata !"iPrev", metadata !5, i32 50331701, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [iPrev] [line 53]
!89 = metadata !{i32 786688, metadata !19, metadata !"qNew", metadata !5, i32 55, metadata !40, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [qNew] [line 55]
!90 = metadata !{i32 55, i32 0, metadata !19, null}
!91 = metadata !{i32 786688, metadata !19, metadata !"qLast", metadata !5, i32 56, metadata !40, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [qLast] [line 56]
!92 = metadata !{i32 56, i32 0, metadata !19, null}
!93 = metadata !{i32 58, i32 0, metadata !94, null} ; [ DW_TAG_imported_module ]
!94 = metadata !{i32 786443, metadata !1, metadata !19, i32 58, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!95 = metadata !{i32 60, i32 0, metadata !96, null}
!96 = metadata !{i32 786443, metadata !1, metadata !94, i32 59, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!97 = metadata !{i32 61, i32 0, metadata !96, null}
!98 = metadata !{i32 63, i32 0, metadata !19, null}
!99 = metadata !{i32 64, i32 0, metadata !19, null}
!100 = metadata !{i32 65, i32 0, metadata !19, null}
!101 = metadata !{i32 66, i32 0, metadata !19, null}
!102 = metadata !{i32 68, i32 0, metadata !103, null}
!103 = metadata !{i32 786443, metadata !1, metadata !19, i32 68, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!104 = metadata !{i32 70, i32 0, metadata !105, null}
!105 = metadata !{i32 786443, metadata !1, metadata !103, i32 69, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!106 = metadata !{i32 71, i32 0, metadata !105, null}
!107 = metadata !{i32 74, i32 0, metadata !108, null}
!108 = metadata !{i32 786443, metadata !1, metadata !103, i32 73, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!109 = metadata !{i32 75, i32 0, metadata !108, null}
!110 = metadata !{i32 77, i32 0, metadata !19, null}
!111 = metadata !{i32 79, i32 0, metadata !19, null}
!112 = metadata !{i32 786689, metadata !22, metadata !"piNode", metadata !5, i32 16777298, metadata !25, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [piNode] [line 82]
!113 = metadata !{i32 82, i32 0, metadata !22, null}
!114 = metadata !{i32 786689, metadata !22, metadata !"piDist", metadata !5, i32 33554514, metadata !25, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [piDist] [line 82]
!115 = metadata !{i32 786689, metadata !22, metadata !"piPrev", metadata !5, i32 50331730, metadata !25, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [piPrev] [line 82]
!116 = metadata !{i32 786688, metadata !22, metadata !"qKill", metadata !5, i32 84, metadata !40, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [qKill] [line 84]
!117 = metadata !{i32 84, i32 0, metadata !22, null}
!118 = metadata !{i32 86, i32 0, metadata !119, null}
!119 = metadata !{i32 786443, metadata !1, metadata !22, i32 86, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!120 = metadata !{i32 89, i32 0, metadata !121, null}
!121 = metadata !{i32 786443, metadata !1, metadata !119, i32 87, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!122 = metadata !{i32 90, i32 0, metadata !121, null}
!123 = metadata !{i32 91, i32 0, metadata !121, null}
!124 = metadata !{i32 92, i32 0, metadata !121, null}
!125 = metadata !{i32 93, i32 0, metadata !121, null}
!126 = metadata !{i32 94, i32 0, metadata !121, null}
!127 = metadata !{i32 95, i32 0, metadata !121, null}
!128 = metadata !{i32 96, i32 0, metadata !22, null}
!129 = metadata !{i32 101, i32 0, metadata !26, null}
!130 = metadata !{i32 786689, metadata !29, metadata !"chStart", metadata !5, i32 16777320, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [chStart] [line 104]
!131 = metadata !{i32 104, i32 0, metadata !29, null}
!132 = metadata !{i32 786689, metadata !29, metadata !"chEnd", metadata !5, i32 33554536, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [chEnd] [line 104]
!133 = metadata !{i32 109, i32 0, metadata !134, null}
!134 = metadata !{i32 786443, metadata !1, metadata !29, i32 109, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!135 = metadata !{i32 111, i32 0, metadata !136, null}
!136 = metadata !{i32 786443, metadata !1, metadata !134, i32 110, i32 0, i32 12} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!137 = metadata !{i32 112, i32 0, metadata !136, null}
!138 = metadata !{i32 113, i32 0, metadata !136, null}
!139 = metadata !{i32 115, i32 0, metadata !140, null}
!140 = metadata !{i32 786443, metadata !1, metadata !29, i32 115, i32 0, i32 13} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!141 = metadata !{i32 117, i32 0, metadata !142, null}
!142 = metadata !{i32 786443, metadata !1, metadata !140, i32 116, i32 0, i32 14} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!143 = metadata !{i32 118, i32 0, metadata !142, null}
!144 = metadata !{i32 121, i32 0, metadata !145, null}
!145 = metadata !{i32 786443, metadata !1, metadata !140, i32 120, i32 0, i32 15} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!146 = metadata !{i32 122, i32 0, metadata !145, null}
!147 = metadata !{i32 124, i32 0, metadata !145, null}
!148 = metadata !{i32 126, i32 0, metadata !145, null}
!149 = metadata !{i32 128, i32 0, metadata !150, null}
!150 = metadata !{i32 786443, metadata !1, metadata !145, i32 127, i32 0, i32 16} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!151 = metadata !{i32 129, i32 0, metadata !152, null}
!152 = metadata !{i32 786443, metadata !1, metadata !150, i32 129, i32 0, i32 17} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!153 = metadata !{i32 131, i32 0, metadata !154, null}
!154 = metadata !{i32 786443, metadata !1, metadata !155, i32 131, i32 0, i32 19} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!155 = metadata !{i32 786443, metadata !1, metadata !152, i32 130, i32 0, i32 18} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!156 = metadata !{i32 133, i32 0, metadata !157, null}
!157 = metadata !{i32 786443, metadata !1, metadata !158, i32 133, i32 0, i32 21} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!158 = metadata !{i32 786443, metadata !1, metadata !154, i32 132, i32 0, i32 20} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!159 = metadata !{i32 136, i32 0, metadata !160, null}
!160 = metadata !{i32 786443, metadata !1, metadata !157, i32 135, i32 0, i32 22} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!161 = metadata !{i32 137, i32 0, metadata !160, null}
!162 = metadata !{i32 138, i32 0, metadata !160, null}
!163 = metadata !{i32 139, i32 0, metadata !160, null}
!164 = metadata !{i32 140, i32 0, metadata !158, null}
!165 = metadata !{i32 141, i32 0, metadata !155, null}
!166 = metadata !{i32 142, i32 0, metadata !150, null}
!167 = metadata !{i32 144, i32 0, metadata !145, null}
!168 = metadata !{i32 145, i32 0, metadata !145, null}
!169 = metadata !{i32 146, i32 0, metadata !145, null}
!170 = metadata !{i32 147, i32 0, metadata !145, null}
!171 = metadata !{i32 149, i32 0, metadata !29, null}
!172 = metadata !{i32 786689, metadata !32, metadata !"argc", metadata !5, i32 16777367, metadata !17, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argc] [line 151]
!173 = metadata !{i32 151, i32 0, metadata !32, null}
!174 = metadata !{i32 786689, metadata !32, metadata !"argv", metadata !5, i32 33554583, metadata !35, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argv] [line 151]
!175 = metadata !{i32 786688, metadata !32, metadata !"i", metadata !5, i32 152, metadata !17, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 152]
!176 = metadata !{i32 152, i32 0, metadata !32, null}
!177 = metadata !{i32 786688, metadata !32, metadata !"j", metadata !5, i32 152, metadata !17, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [j] [line 152]
!178 = metadata !{i32 786688, metadata !32, metadata !"k", metadata !5, i32 152, metadata !17, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [k] [line 152]
!179 = metadata !{i32 786688, metadata !32, metadata !"fp", metadata !5, i32 153, metadata !180, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [fp] [line 153]
!180 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !181} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from FILE]
!181 = metadata !{i32 786454, metadata !1, null, metadata !"FILE", i32 48, i64 0, i64 0, i64 0, i32 0, metadata !182} ; [ DW_TAG_typedef ] [FILE] [line 48, size 0, align 0, offset 0] [from _IO_FILE]
!182 = metadata !{i32 786451, metadata !183, null, metadata !"_IO_FILE", i32 245, i64 1728, i64 64, i32 0, i32 0, null, metadata !184, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [_IO_FILE] [line 245, size 1728, align 64, offset 0] [def] [from ]
!183 = metadata !{metadata !"/usr/include/libio.h", metadata !"/home/yan/mibench/network/dijkstra"}
!184 = metadata !{metadata !185, metadata !186, metadata !187, metadata !188, metadata !189, metadata !190, metadata !191, metadata !192, metadata !193, metadata !194, metadata !195, metadata !196, metadata !197, metadata !205, metadata !206, metadata !207, metadata !208, metadata !211, metadata !213, metadata !215, metadata !219, metadata !221, metadata !223, metadata !224, metadata !225, metadata !226, metadata !227, metadata !230, metadata !231}
!185 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_flags", i32 246, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_member ] [_flags] [line 246, size 32, align 32, offset 0] [from int]
!186 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_read_ptr", i32 251, i64 64, i64 64, i64 64, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_read_ptr] [line 251, size 64, align 64, offset 64] [from ]
!187 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_read_end", i32 252, i64 64, i64 64, i64 128, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_read_end] [line 252, size 64, align 64, offset 128] [from ]
!188 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_read_base", i32 253, i64 64, i64 64, i64 192, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_read_base] [line 253, size 64, align 64, offset 192] [from ]
!189 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_write_base", i32 254, i64 64, i64 64, i64 256, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_write_base] [line 254, size 64, align 64, offset 256] [from ]
!190 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_write_ptr", i32 255, i64 64, i64 64, i64 320, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_write_ptr] [line 255, size 64, align 64, offset 320] [from ]
!191 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_write_end", i32 256, i64 64, i64 64, i64 384, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_write_end] [line 256, size 64, align 64, offset 384] [from ]
!192 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_buf_base", i32 257, i64 64, i64 64, i64 448, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_buf_base] [line 257, size 64, align 64, offset 448] [from ]
!193 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_buf_end", i32 258, i64 64, i64 64, i64 512, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_buf_end] [line 258, size 64, align 64, offset 512] [from ]
!194 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_save_base", i32 260, i64 64, i64 64, i64 576, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_save_base] [line 260, size 64, align 64, offset 576] [from ]
!195 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_backup_base", i32 261, i64 64, i64 64, i64 640, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_backup_base] [line 261, size 64, align 64, offset 640] [from ]
!196 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_IO_save_end", i32 262, i64 64, i64 64, i64 704, i32 0, metadata !36} ; [ DW_TAG_member ] [_IO_save_end] [line 262, size 64, align 64, offset 704] [from ]
!197 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_markers", i32 264, i64 64, i64 64, i64 768, i32 0, metadata !198} ; [ DW_TAG_member ] [_markers] [line 264, size 64, align 64, offset 768] [from ]
!198 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !199} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from _IO_marker]
!199 = metadata !{i32 786451, metadata !183, null, metadata !"_IO_marker", i32 160, i64 192, i64 64, i32 0, i32 0, null, metadata !200, i32 0, null, null, null} ; [ DW_TAG_structure_type ] [_IO_marker] [line 160, size 192, align 64, offset 0] [def] [from ]
!200 = metadata !{metadata !201, metadata !202, metadata !204}
!201 = metadata !{i32 786445, metadata !183, metadata !199, metadata !"_next", i32 161, i64 64, i64 64, i64 0, i32 0, metadata !198} ; [ DW_TAG_member ] [_next] [line 161, size 64, align 64, offset 0] [from ]
!202 = metadata !{i32 786445, metadata !183, metadata !199, metadata !"_sbuf", i32 162, i64 64, i64 64, i64 64, i32 0, metadata !203} ; [ DW_TAG_member ] [_sbuf] [line 162, size 64, align 64, offset 64] [from ]
!203 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !182} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from _IO_FILE]
!204 = metadata !{i32 786445, metadata !183, metadata !199, metadata !"_pos", i32 166, i64 32, i64 32, i64 128, i32 0, metadata !17} ; [ DW_TAG_member ] [_pos] [line 166, size 32, align 32, offset 128] [from int]
!205 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_chain", i32 266, i64 64, i64 64, i64 832, i32 0, metadata !203} ; [ DW_TAG_member ] [_chain] [line 266, size 64, align 64, offset 832] [from ]
!206 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_fileno", i32 268, i64 32, i64 32, i64 896, i32 0, metadata !17} ; [ DW_TAG_member ] [_fileno] [line 268, size 32, align 32, offset 896] [from int]
!207 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_flags2", i32 272, i64 32, i64 32, i64 928, i32 0, metadata !17} ; [ DW_TAG_member ] [_flags2] [line 272, size 32, align 32, offset 928] [from int]
!208 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_old_offset", i32 274, i64 64, i64 64, i64 960, i32 0, metadata !209} ; [ DW_TAG_member ] [_old_offset] [line 274, size 64, align 64, offset 960] [from __off_t]
!209 = metadata !{i32 786454, metadata !183, null, metadata !"__off_t", i32 131, i64 0, i64 0, i64 0, i32 0, metadata !210} ; [ DW_TAG_typedef ] [__off_t] [line 131, size 0, align 0, offset 0] [from long int]
!210 = metadata !{i32 786468, null, null, metadata !"long int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [long int] [line 0, size 64, align 64, offset 0, enc DW_ATE_signed]
!211 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_cur_column", i32 278, i64 16, i64 16, i64 1024, i32 0, metadata !212} ; [ DW_TAG_member ] [_cur_column] [line 278, size 16, align 16, offset 1024] [from unsigned short]
!212 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!213 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_vtable_offset", i32 279, i64 8, i64 8, i64 1040, i32 0, metadata !214} ; [ DW_TAG_member ] [_vtable_offset] [line 279, size 8, align 8, offset 1040] [from signed char]
!214 = metadata !{i32 786468, null, null, metadata !"signed char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [signed char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!215 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_shortbuf", i32 280, i64 8, i64 8, i64 1048, i32 0, metadata !216} ; [ DW_TAG_member ] [_shortbuf] [line 280, size 8, align 8, offset 1048] [from ]
!216 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 8, i64 8, i32 0, i32 0, metadata !37, metadata !217, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 8, align 8, offset 0] [from char]
!217 = metadata !{metadata !218}
!218 = metadata !{i32 786465, i64 0, i64 1}       ; [ DW_TAG_subrange_type ] [0, 0]
!219 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_lock", i32 284, i64 64, i64 64, i64 1088, i32 0, metadata !220} ; [ DW_TAG_member ] [_lock] [line 284, size 64, align 64, offset 1088] [from ]
!220 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!221 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_offset", i32 293, i64 64, i64 64, i64 1152, i32 0, metadata !222} ; [ DW_TAG_member ] [_offset] [line 293, size 64, align 64, offset 1152] [from __off64_t]
!222 = metadata !{i32 786454, metadata !183, null, metadata !"__off64_t", i32 132, i64 0, i64 0, i64 0, i32 0, metadata !210} ; [ DW_TAG_typedef ] [__off64_t] [line 132, size 0, align 0, offset 0] [from long int]
!223 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"__pad1", i32 302, i64 64, i64 64, i64 1216, i32 0, metadata !220} ; [ DW_TAG_member ] [__pad1] [line 302, size 64, align 64, offset 1216] [from ]
!224 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"__pad2", i32 303, i64 64, i64 64, i64 1280, i32 0, metadata !220} ; [ DW_TAG_member ] [__pad2] [line 303, size 64, align 64, offset 1280] [from ]
!225 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"__pad3", i32 304, i64 64, i64 64, i64 1344, i32 0, metadata !220} ; [ DW_TAG_member ] [__pad3] [line 304, size 64, align 64, offset 1344] [from ]
!226 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"__pad4", i32 305, i64 64, i64 64, i64 1408, i32 0, metadata !220} ; [ DW_TAG_member ] [__pad4] [line 305, size 64, align 64, offset 1408] [from ]
!227 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"__pad5", i32 306, i64 64, i64 64, i64 1472, i32 0, metadata !228} ; [ DW_TAG_member ] [__pad5] [line 306, size 64, align 64, offset 1472] [from size_t]
!228 = metadata !{i32 786454, metadata !183, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !229} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from long unsigned int]
!229 = metadata !{i32 786468, null, null, metadata !"long unsigned int", i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [long unsigned int] [line 0, size 64, align 64, offset 0, enc DW_ATE_unsigned]
!230 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_mode", i32 308, i64 32, i64 32, i64 1536, i32 0, metadata !17} ; [ DW_TAG_member ] [_mode] [line 308, size 32, align 32, offset 1536] [from int]
!231 = metadata !{i32 786445, metadata !183, metadata !182, metadata !"_unused2", i32 310, i64 160, i64 8, i64 1568, i32 0, metadata !232} ; [ DW_TAG_member ] [_unused2] [line 310, size 160, align 8, offset 1568] [from ]
!232 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 160, i64 8, i32 0, i32 0, metadata !37, metadata !233, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 160, align 8, offset 0] [from char]
!233 = metadata !{metadata !234}
!234 = metadata !{i32 786465, i64 0, i64 20}      ; [ DW_TAG_subrange_type ] [0, 19]
!235 = metadata !{i32 153, i32 0, metadata !32, null}
!236 = metadata !{i32 157, i32 0, metadata !32, null}
!237 = metadata !{i32 160, i32 0, metadata !238, null}
!238 = metadata !{i32 786443, metadata !1, metadata !32, i32 160, i32 0, i32 23} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!239 = metadata !{i32 161, i32 0, metadata !240, null}
!240 = metadata !{i32 786443, metadata !1, metadata !241, i32 161, i32 0, i32 25} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!241 = metadata !{i32 786443, metadata !1, metadata !238, i32 160, i32 0, i32 24} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!242 = metadata !{i32 163, i32 0, metadata !243, null}
!243 = metadata !{i32 786443, metadata !1, metadata !240, i32 161, i32 0, i32 26} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!244 = metadata !{i32 164, i32 0, metadata !243, null}
!245 = metadata !{i32 165, i32 0, metadata !243, null}
!246 = metadata !{i32 166, i32 0, metadata !241, null}
!247 = metadata !{i32 169, i32 0, metadata !248, null}
!248 = metadata !{i32 786443, metadata !1, metadata !32, i32 169, i32 0, i32 27} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!249 = metadata !{i32 170, i32 0, metadata !250, null}
!250 = metadata !{i32 786443, metadata !1, metadata !248, i32 169, i32 0, i32 28} ; [ DW_TAG_lexical_block ] [/home/yan/mibench/network/dijkstra/dijkstra_small_new.c]
!251 = metadata !{i32 171, i32 0, metadata !250, null}
!252 = metadata !{i32 172, i32 0, metadata !250, null}
!253 = metadata !{i32 173, i32 0, metadata !32, null}
!254 = metadata !{i32 176, i32 0, metadata !32, null}

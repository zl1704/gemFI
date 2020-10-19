; ModuleID = 'tt/qs.ll'
source_filename = "qs.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@s = common dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"init ...\0A\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"sort ...\0A\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"print ...\0A\00", align 1
@BasicBlockSignatureTracker = common global i16 0, align 4
@RunTimeSignatureAdjuster = common global i16 0, align 4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @quick_sort(i32 %l, i32 %r) #0 !dbg !14 {
entry:
  %LoadRTS_79 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_80 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_81 = xor i16 %LoadRTS_79, 23886
  %XOR2_82 = xor i16 %XOR1_81, %LoadRTSAdj_80
  %CmpXORresult_83125 = icmp eq i16 %XOR2_82, 124
  br i1 %CmpXORresult_83125, label %quick_sort.split126, label %CFerrorHandler.quick_sort

quick_sort.split126:                              ; preds = %entry
  %LoadRTS_74 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_75 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_76 = xor i16 %LoadRTS_74, 23886
  %XOR2_77 = xor i16 %XOR1_76, %LoadRTSAdj_75
  %CmpXORresult_78123 = icmp eq i16 %XOR2_77, 124
  br i1 %CmpXORresult_78123, label %quick_sort.split124, label %CFerrorHandler.quick_sort

quick_sort.split124:                              ; preds = %quick_sort.split126
  %LoadRTS_69 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_70 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_71 = xor i16 %LoadRTS_69, 23886
  %XOR2_72 = xor i16 %XOR1_71, %LoadRTSAdj_70
  %CmpXORresult_73121 = icmp eq i16 %XOR2_72, 124
  br i1 %CmpXORresult_73121, label %quick_sort.split122, label %CFerrorHandler.quick_sort

quick_sort.split122:                              ; preds = %quick_sort.split124
  %l.addr = alloca i32, align 4
  %r.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %l, i32* %l.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %l.addr, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 %r, i32* %r.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %r.addr, metadata !19, metadata !DIExpression()), !dbg !20
  %0 = load i32, i32* %l.addr, align 4, !dbg !21
  %1 = load i32, i32* %r.addr, align 4, !dbg !23
  %cmp = icmp slt i32 %0, %1, !dbg !24
  store i16 124, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp, label %if.then, label %if.end35, !dbg !25

if.then:                                          ; preds = %quick_sort.split122
  %LoadRTS_ = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_ = xor i16 %LoadRTS_, 2022
  %CmpXORresult_84 = icmp eq i16 %XOR1_, 1946
  br i1 %CmpXORresult_84, label %quick_sort.split, label %CFerrorHandler.quick_sort

quick_sort.split:                                 ; preds = %if.then
  call void @llvm.dbg.declare(metadata i32* %i, metadata !26, metadata !DIExpression()), !dbg !28
  %2 = load i32, i32* %l.addr, align 4, !dbg !29
  store i32 %2, i32* %i, align 4, !dbg !28
  call void @llvm.dbg.declare(metadata i32* %j, metadata !30, metadata !DIExpression()), !dbg !31
  %3 = load i32, i32* %r.addr, align 4, !dbg !32
  store i32 %3, i32* %j, align 4, !dbg !31
  call void @llvm.dbg.declare(metadata i32* %x, metadata !33, metadata !DIExpression()), !dbg !34
  %4 = load i32, i32* %l.addr, align 4, !dbg !35
  %idxprom = sext i32 %4 to i64, !dbg !36
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom, !dbg !36
  %5 = load i32, i32* %arrayidx, align 4, !dbg !36
  store i32 %5, i32* %x, align 4, !dbg !34
  store i16 1946, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %while.cond, !dbg !37

while.cond:                                       ; preds = %quick_sort.split120, %quick_sort.split
  %LoadRTS_4 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_5 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_6 = xor i16 %LoadRTS_4, 4046
  %XOR2_7 = xor i16 %XOR1_6, %LoadRTSAdj_5
  %CmpXORresult_887 = icmp eq i16 %XOR2_7, 2132
  br i1 %CmpXORresult_887, label %quick_sort.split88, label %CFerrorHandler.quick_sort

quick_sort.split88:                               ; preds = %while.cond
  %6 = load i32, i32* %i, align 4, !dbg !38
  %7 = load i32, i32* %j, align 4, !dbg !39
  %cmp1 = icmp slt i32 %6, %7, !dbg !40
  store i16 2132, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp1, label %while.body, label %while.end32, !dbg !37

while.body:                                       ; preds = %quick_sort.split88
  %LoadRTS_9 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_10 = xor i16 %LoadRTS_9, 1826
  %CmpXORresult_1189 = icmp eq i16 %XOR1_10, 3958
  br i1 %CmpXORresult_1189, label %quick_sort.split90, label %CFerrorHandler.quick_sort

quick_sort.split90:                               ; preds = %while.body
  store i16 3958, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %while.cond2, !dbg !41

while.cond2:                                      ; preds = %quick_sort.split100, %quick_sort.split90
  %LoadRTS_15 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_16 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_17 = xor i16 %LoadRTS_15, 4493
  %XOR2_18 = xor i16 %XOR1_17, %LoadRTSAdj_16
  %CmpXORresult_1993 = icmp eq i16 %XOR2_18, 7931
  br i1 %CmpXORresult_1993, label %quick_sort.split94, label %CFerrorHandler.quick_sort

quick_sort.split94:                               ; preds = %while.cond2
  %8 = load i32, i32* %i, align 4, !dbg !43
  %9 = load i32, i32* %j, align 4, !dbg !44
  %cmp3 = icmp slt i32 %8, %9, !dbg !45
  store i16 7931, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp3, label %land.rhs, label %land.end, !dbg !46

land.rhs:                                         ; preds = %quick_sort.split94
  %LoadRTS_20 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_21 = xor i16 %LoadRTS_20, 466
  %CmpXORresult_2295 = icmp eq i16 %XOR1_21, 7977
  br i1 %CmpXORresult_2295, label %quick_sort.split96, label %CFerrorHandler.quick_sort

quick_sort.split96:                               ; preds = %land.rhs
  %10 = load i32, i32* %j, align 4, !dbg !47
  %idxprom4 = sext i32 %10 to i64, !dbg !48
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom4, !dbg !48
  %11 = load i32, i32* %arrayidx5, align 4, !dbg !48
  %12 = load i32, i32* %x, align 4, !dbg !49
  %cmp6 = icmp sge i32 %11, %12, !dbg !50
  store i16 7977, i16* @BasicBlockSignatureTracker
  store i16 466, i16* @RunTimeSignatureAdjuster
  br label %land.end

land.end:                                         ; preds = %quick_sort.split96, %quick_sort.split94
  %13 = phi i1 [ false, %quick_sort.split94 ], [ %cmp6, %quick_sort.split96 ], !dbg !51
  %LoadRTS_23 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_24 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_25 = xor i16 %LoadRTS_23, 15840
  %XOR2_26 = xor i16 %XOR1_25, %LoadRTSAdj_24
  %CmpXORresult_2797 = icmp eq i16 %XOR2_26, 8987
  br i1 %CmpXORresult_2797, label %quick_sort.split98, label %CFerrorHandler.quick_sort

quick_sort.split98:                               ; preds = %land.end
  store i16 8987, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %13, label %while.body7, label %while.end, !dbg !41

while.body7:                                      ; preds = %quick_sort.split98
  %LoadRTS_28 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_29 = xor i16 %LoadRTS_28, 221
  %CmpXORresult_3099 = icmp eq i16 %XOR1_29, 9158
  br i1 %CmpXORresult_3099, label %quick_sort.split100, label %CFerrorHandler.quick_sort

quick_sort.split100:                              ; preds = %while.body7
  %14 = load i32, i32* %j, align 4, !dbg !52
  %dec = add nsw i32 %14, -1, !dbg !52
  store i32 %dec, i32* %j, align 4, !dbg !52
  store i16 9158, i16* @BasicBlockSignatureTracker
  store i16 11440, i16* @RunTimeSignatureAdjuster
  br label %while.cond2, !dbg !41, !llvm.loop !53

while.end:                                        ; preds = %quick_sort.split98
  %LoadRTS_31 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_32 = xor i16 %LoadRTS_31, 1601
  %CmpXORresult_33101 = icmp eq i16 %XOR1_32, 9562
  br i1 %CmpXORresult_33101, label %quick_sort.split102, label %CFerrorHandler.quick_sort

quick_sort.split102:                              ; preds = %while.end
  %15 = load i32, i32* %i, align 4, !dbg !54
  %16 = load i32, i32* %j, align 4, !dbg !56
  %cmp8 = icmp slt i32 %15, %16, !dbg !57
  store i16 9562, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp8, label %if.then9, label %if.end, !dbg !58

if.then9:                                         ; preds = %quick_sort.split102
  %LoadRTS_34 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_35 = xor i16 %LoadRTS_34, 674
  %CmpXORresult_36103 = icmp eq i16 %XOR1_35, 10232
  br i1 %CmpXORresult_36103, label %quick_sort.split104, label %CFerrorHandler.quick_sort

quick_sort.split104:                              ; preds = %if.then9
  %17 = load i32, i32* %j, align 4, !dbg !59
  %idxprom10 = sext i32 %17 to i64, !dbg !60
  %arrayidx11 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom10, !dbg !60
  %18 = load i32, i32* %arrayidx11, align 4, !dbg !60
  %19 = load i32, i32* %i, align 4, !dbg !61
  %inc = add nsw i32 %19, 1, !dbg !61
  store i32 %inc, i32* %i, align 4, !dbg !61
  %idxprom12 = sext i32 %19 to i64, !dbg !62
  %arrayidx13 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom12, !dbg !62
  store i32 %18, i32* %arrayidx13, align 4, !dbg !63
  store i16 10232, i16* @BasicBlockSignatureTracker
  store i16 674, i16* @RunTimeSignatureAdjuster
  br label %if.end, !dbg !62

if.end:                                           ; preds = %quick_sort.split104, %quick_sort.split102
  %LoadRTS_37 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_38 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_39 = xor i16 %LoadRTS_37, 25768
  %XOR2_40 = xor i16 %XOR1_39, %LoadRTSAdj_38
  %CmpXORresult_41105 = icmp eq i16 %XOR2_40, 16882
  br i1 %CmpXORresult_41105, label %quick_sort.split106, label %CFerrorHandler.quick_sort

quick_sort.split106:                              ; preds = %if.end
  store i16 16882, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %while.cond14, !dbg !64

while.cond14:                                     ; preds = %quick_sort.split114, %quick_sort.split106
  %LoadRTS_42 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_43 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_44 = xor i16 %LoadRTS_42, 639
  %XOR2_45 = xor i16 %XOR1_44, %LoadRTSAdj_43
  %CmpXORresult_46107 = icmp eq i16 %XOR2_45, 17293
  br i1 %CmpXORresult_46107, label %quick_sort.split108, label %CFerrorHandler.quick_sort

quick_sort.split108:                              ; preds = %while.cond14
  %20 = load i32, i32* %i, align 4, !dbg !65
  %21 = load i32, i32* %j, align 4, !dbg !66
  %cmp15 = icmp slt i32 %20, %21, !dbg !67
  store i16 17293, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp15, label %land.rhs16, label %land.end20, !dbg !68

land.rhs16:                                       ; preds = %quick_sort.split108
  %LoadRTS_47 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_48 = xor i16 %LoadRTS_47, 1770
  %CmpXORresult_49109 = icmp eq i16 %XOR1_48, 17767
  br i1 %CmpXORresult_49109, label %quick_sort.split110, label %CFerrorHandler.quick_sort

quick_sort.split110:                              ; preds = %land.rhs16
  %22 = load i32, i32* %i, align 4, !dbg !69
  %idxprom17 = sext i32 %22 to i64, !dbg !70
  %arrayidx18 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom17, !dbg !70
  %23 = load i32, i32* %arrayidx18, align 4, !dbg !70
  %24 = load i32, i32* %x, align 4, !dbg !71
  %cmp19 = icmp slt i32 %23, %24, !dbg !72
  store i16 17767, i16* @BasicBlockSignatureTracker
  store i16 1770, i16* @RunTimeSignatureAdjuster
  br label %land.end20

land.end20:                                       ; preds = %quick_sort.split110, %quick_sort.split108
  %25 = phi i1 [ false, %quick_sort.split108 ], [ %cmp19, %quick_sort.split110 ], !dbg !51
  %LoadRTS_50 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_51 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_52 = xor i16 %LoadRTS_50, 3070
  %XOR2_53 = xor i16 %XOR1_52, %LoadRTSAdj_51
  %CmpXORresult_54111 = icmp eq i16 %XOR2_53, 18547
  br i1 %CmpXORresult_54111, label %quick_sort.split112, label %CFerrorHandler.quick_sort

quick_sort.split112:                              ; preds = %land.end20
  store i16 18547, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %25, label %while.body21, label %while.end23, !dbg !64

while.body21:                                     ; preds = %quick_sort.split112
  %LoadRTS_55 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_56 = xor i16 %LoadRTS_55, 6270
  %CmpXORresult_57113 = icmp eq i16 %XOR1_56, 20493
  br i1 %CmpXORresult_57113, label %quick_sort.split114, label %CFerrorHandler.quick_sort

quick_sort.split114:                              ; preds = %while.body21
  %26 = load i32, i32* %i, align 4, !dbg !73
  %inc22 = add nsw i32 %26, 1, !dbg !73
  store i32 %inc22, i32* %i, align 4, !dbg !73
  store i16 20493, i16* @BasicBlockSignatureTracker
  store i16 4607, i16* @RunTimeSignatureAdjuster
  br label %while.cond14, !dbg !64, !llvm.loop !74

while.end23:                                      ; preds = %quick_sort.split112
  %LoadRTS_58 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_59 = xor i16 %LoadRTS_58, 4297
  %CmpXORresult_60115 = icmp eq i16 %XOR1_59, 22714
  br i1 %CmpXORresult_60115, label %quick_sort.split116, label %CFerrorHandler.quick_sort

quick_sort.split116:                              ; preds = %while.end23
  %27 = load i32, i32* %i, align 4, !dbg !75
  %28 = load i32, i32* %j, align 4, !dbg !77
  %cmp24 = icmp slt i32 %27, %28, !dbg !78
  store i16 22714, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp24, label %if.then25, label %if.end31, !dbg !79

if.then25:                                        ; preds = %quick_sort.split116
  %LoadRTS_61 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_62 = xor i16 %LoadRTS_61, 86
  %CmpXORresult_63117 = icmp eq i16 %XOR1_62, 22764
  br i1 %CmpXORresult_63117, label %quick_sort.split118, label %CFerrorHandler.quick_sort

quick_sort.split118:                              ; preds = %if.then25
  %29 = load i32, i32* %i, align 4, !dbg !80
  %idxprom26 = sext i32 %29 to i64, !dbg !81
  %arrayidx27 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom26, !dbg !81
  %30 = load i32, i32* %arrayidx27, align 4, !dbg !81
  %31 = load i32, i32* %j, align 4, !dbg !82
  %dec28 = add nsw i32 %31, -1, !dbg !82
  store i32 %dec28, i32* %j, align 4, !dbg !82
  %idxprom29 = sext i32 %31 to i64, !dbg !83
  %arrayidx30 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom29, !dbg !83
  store i32 %30, i32* %arrayidx30, align 4, !dbg !84
  store i16 22764, i16* @BasicBlockSignatureTracker
  store i16 86, i16* @RunTimeSignatureAdjuster
  br label %if.end31, !dbg !83

if.end31:                                         ; preds = %quick_sort.split118, %quick_sort.split116
  %LoadRTS_64 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_65 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_66 = xor i16 %LoadRTS_64, 1093
  %XOR2_67 = xor i16 %XOR1_66, %LoadRTSAdj_65
  %CmpXORresult_68119 = icmp eq i16 %XOR2_67, 23807
  br i1 %CmpXORresult_68119, label %quick_sort.split120, label %CFerrorHandler.quick_sort

quick_sort.split120:                              ; preds = %if.end31
  store i16 23807, i16* @BasicBlockSignatureTracker
  store i16 23397, i16* @RunTimeSignatureAdjuster
  br label %while.cond, !dbg !37, !llvm.loop !85

while.end32:                                      ; preds = %quick_sort.split88
  %LoadRTS_12 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_13 = xor i16 %LoadRTS_12, 21862
  %CmpXORresult_1491 = icmp eq i16 %XOR1_13, 23858
  br i1 %CmpXORresult_1491, label %quick_sort.split92, label %CFerrorHandler.quick_sort

quick_sort.split92:                               ; preds = %while.end32
  %32 = load i32, i32* %x, align 4, !dbg !87
  %33 = load i32, i32* %i, align 4, !dbg !88
  %idxprom33 = sext i32 %33 to i64, !dbg !89
  %arrayidx34 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom33, !dbg !89
  store i32 %32, i32* %arrayidx34, align 4, !dbg !90
  %34 = load i32, i32* %l.addr, align 4, !dbg !91
  %35 = load i32, i32* %i, align 4, !dbg !92
  %sub = sub nsw i32 %35, 1, !dbg !93
  store i16 23858, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  call void @quick_sort(i32 %34, i32 %sub), !dbg !94
  store i16 23858, i16* @BasicBlockSignatureTracker
  store i16 23886, i16* @RunTimeSignatureAdjuster
  %36 = load i32, i32* %i, align 4, !dbg !95
  %add = add nsw i32 %36, 1, !dbg !96
  %37 = load i32, i32* %r.addr, align 4, !dbg !97
  store i16 23858, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  call void @quick_sort(i32 %add, i32 %37), !dbg !98
  store i16 23858, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  store i16 23858, i16* @BasicBlockSignatureTracker
  store i16 23886, i16* @RunTimeSignatureAdjuster
  br label %if.end35, !dbg !99

if.end35:                                         ; preds = %quick_sort.split92, %quick_sort.split122
  %LoadRTS_1 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_ = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_2 = xor i16 %LoadRTS_1, 25278
  %XOR2_ = xor i16 %XOR1_2, %LoadRTSAdj_
  %CmpXORresult_385 = icmp eq i16 %XOR2_, 25282
  br i1 %CmpXORresult_385, label %quick_sort.split86, label %CFerrorHandler.quick_sort

quick_sort.split86:                               ; preds = %if.end35
  store i16 25282, i16* @BasicBlockSignatureTracker
  store i16 27286, i16* @RunTimeSignatureAdjuster
  ret void, !dbg !100

CFerrorHandler.quick_sort:                        ; preds = %entry, %quick_sort.split126, %quick_sort.split124, %if.end31, %if.then25, %while.end23, %while.body21, %land.end20, %land.rhs16, %while.cond14, %if.end, %if.then9, %while.end, %while.body7, %land.end, %land.rhs, %while.cond2, %while.end32, %while.body, %while.cond, %if.end35, %if.then
  call void @FAULT_DETECTED_CFC()
  unreachable
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print() #0 !dbg !101 {
entry:
  %LoadRTS_10 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_11 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_12 = xor i16 %LoadRTS_10, -25205
  %XOR2_13 = xor i16 %XOR1_12, %LoadRTSAdj_11
  %CmpXORresult_1422 = icmp eq i16 %XOR2_13, 31949
  br i1 %CmpXORresult_1422, label %print.split23, label %CFerrorHandler.print

print.split23:                                    ; preds = %entry
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !104, metadata !DIExpression()), !dbg !106
  store i32 0, i32* %i, align 4, !dbg !106
  store i16 31949, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %for.cond, !dbg !107

for.cond:                                         ; preds = %print.split21, %print.split23
  %LoadRTS_ = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_ = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_ = xor i16 %LoadRTS_, -6009
  %XOR2_ = xor i16 %XOR1_, %LoadRTSAdj_
  %CmpXORresult_15 = icmp eq i16 %XOR2_, -27574
  br i1 %CmpXORresult_15, label %print.split, label %CFerrorHandler.print

print.split:                                      ; preds = %for.cond
  %0 = load i32, i32* %i, align 4, !dbg !108
  %cmp = icmp slt i32 %0, 50, !dbg !110
  store i16 -27574, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp, label %for.body, label %for.end, !dbg !111

for.body:                                         ; preds = %print.split
  %LoadRTS_1 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_2 = xor i16 %LoadRTS_1, 3107
  %CmpXORresult_316 = icmp eq i16 %XOR1_2, -26519
  br i1 %CmpXORresult_316, label %print.split17, label %CFerrorHandler.print

print.split17:                                    ; preds = %for.body
  %1 = load i32, i32* %i, align 4, !dbg !112
  %idxprom = sext i32 %1 to i64, !dbg !113
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom, !dbg !113
  %2 = load i32, i32* %arrayidx, align 4, !dbg !113
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %2), !dbg !114
  store i16 -26519, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %for.inc, !dbg !114

for.inc:                                          ; preds = %print.split17
  %LoadRTS_7 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_8 = xor i16 %LoadRTS_7, 12682
  %CmpXORresult_920 = icmp eq i16 %XOR1_8, -22045
  br i1 %CmpXORresult_920, label %print.split21, label %CFerrorHandler.print

print.split21:                                    ; preds = %for.inc
  %3 = load i32, i32* %i, align 4, !dbg !115
  %inc = add nsw i32 %3, 1, !dbg !115
  store i32 %inc, i32* %i, align 4, !dbg !115
  store i16 -22045, i16* @BasicBlockSignatureTracker
  store i16 -10962, i16* @RunTimeSignatureAdjuster
  br label %for.cond, !dbg !116, !llvm.loop !117

for.end:                                          ; preds = %print.split
  %LoadRTS_4 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_5 = xor i16 %LoadRTS_4, 11899
  %CmpXORresult_618 = icmp eq i16 %XOR1_5, -17871
  br i1 %CmpXORresult_618, label %print.split19, label %CFerrorHandler.print

print.split19:                                    ; preds = %for.end
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0)), !dbg !119
  store i16 -17871, i16* @BasicBlockSignatureTracker
  store i16 28038, i16* @RunTimeSignatureAdjuster
  ret void, !dbg !120

CFerrorHandler.print:                             ; preds = %entry, %for.inc, %for.end, %for.body, %for.cond
  call void @FAULT_DETECTED_CFC()
  unreachable
}

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init() #0 !dbg !121 {
entry:
  %LoadRTS_10 = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_11 = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_12 = xor i16 %LoadRTS_10, 9615
  %XOR2_13 = xor i16 %XOR1_12, %LoadRTSAdj_11
  %CmpXORresult_1422 = icmp eq i16 %XOR2_13, -15159
  br i1 %CmpXORresult_1422, label %init.split23, label %CFerrorHandler.init

init.split23:                                     ; preds = %entry
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !122, metadata !DIExpression()), !dbg !124
  store i32 0, i32* %i, align 4, !dbg !124
  store i16 -15159, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %for.cond, !dbg !125

for.cond:                                         ; preds = %init.split21, %init.split23
  %LoadRTS_ = load i16, i16* @BasicBlockSignatureTracker
  %LoadRTSAdj_ = load i16, i16* @RunTimeSignatureAdjuster
  %XOR1_ = xor i16 %LoadRTS_, 2350
  %XOR2_ = xor i16 %XOR1_, %LoadRTSAdj_
  %CmpXORresult_15 = icmp eq i16 %XOR2_, -12825
  br i1 %CmpXORresult_15, label %init.split, label %CFerrorHandler.init

init.split:                                       ; preds = %for.cond
  %0 = load i32, i32* %i, align 4, !dbg !126
  %cmp = icmp slt i32 %0, 100, !dbg !128
  store i16 -12825, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br i1 %cmp, label %for.body, label %for.end, !dbg !129

for.body:                                         ; preds = %init.split
  %LoadRTS_1 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_2 = xor i16 %LoadRTS_1, 6776
  %CmpXORresult_316 = icmp eq i16 %XOR1_2, -10337
  br i1 %CmpXORresult_316, label %init.split17, label %CFerrorHandler.init

init.split17:                                     ; preds = %for.body
  %1 = load i32, i32* %i, align 4, !dbg !130
  %sub = sub nsw i32 100, %1, !dbg !132
  %2 = load i32, i32* %i, align 4, !dbg !133
  %idxprom = sext i32 %2 to i64, !dbg !134
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom, !dbg !134
  store i32 %sub, i32* %arrayidx, align 4, !dbg !135
  store i16 -10337, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  br label %for.inc, !dbg !136

for.inc:                                          ; preds = %init.split17
  %LoadRTS_7 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_8 = xor i16 %LoadRTS_7, 52
  %CmpXORresult_920 = icmp eq i16 %XOR1_8, -10325
  br i1 %CmpXORresult_920, label %init.split21, label %CFerrorHandler.init

init.split21:                                     ; preds = %for.inc
  %3 = load i32, i32* %i, align 4, !dbg !137
  %inc = add nsw i32 %3, 1, !dbg !137
  store i32 %inc, i32* %i, align 4, !dbg !137
  store i16 -10325, i16* @BasicBlockSignatureTracker
  store i16 4962, i16* @RunTimeSignatureAdjuster
  br label %for.cond, !dbg !138, !llvm.loop !139

for.end:                                          ; preds = %init.split
  %LoadRTS_4 = load i16, i16* @BasicBlockSignatureTracker
  %XOR1_5 = xor i16 %LoadRTS_4, 6736
  %CmpXORresult_618 = icmp eq i16 %XOR1_5, -10313
  br i1 %CmpXORresult_618, label %init.split19, label %CFerrorHandler.init

init.split19:                                     ; preds = %for.end
  store i16 -10313, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  ret void, !dbg !141

CFerrorHandler.init:                              ; preds = %entry, %for.inc, %for.end, %for.body, %for.cond
  call void @FAULT_DETECTED_CFC()
  unreachable
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !142 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !148, metadata !DIExpression()), !dbg !149
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !150, metadata !DIExpression()), !dbg !151
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i32 0, i32 0)), !dbg !152
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  call void @init(), !dbg !153
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0)), !dbg !154
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 -17292, i16* @RunTimeSignatureAdjuster
  call void @quick_sort(i32 0, i32 99), !dbg !155
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 -17292, i16* @RunTimeSignatureAdjuster
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.4, i32 0, i32 0)), !dbg !156
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  call void @print(), !dbg !157
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 -17292, i16* @RunTimeSignatureAdjuster
  store i16 -7866, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  ret i32 0, !dbg !158

CFerrorHandler.main:                              ; No predecessors!
  call void @FAULT_DETECTED_CFC()
  unreachable
}

define void @FAULT_DETECTED_CFC() {
FAULT_DETECTED_CFC:
  call void @abort()
  store i16 -1746, i16* @BasicBlockSignatureTracker
  store i16 0, i16* @RunTimeSignatureAdjuster
  unreachable

CFerrorHandler.FAULT_DETECTED_CFC:                ; No predecessors!
  call void @FAULT_DETECTED_CFC()
  unreachable
}

declare void @abort()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "s", scope: !2, file: !3, line: 4, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 7.1.0 (tags/RELEASE_710/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5)
!3 = !DIFile(filename: "qs.c", directory: "/home/zl/work/gem5-19.0.0.0/configs/fi")
!4 = !{}
!5 = !{!0}
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 3200, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9}
!9 = !DISubrange(count: 100)
!10 = !{i32 2, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"clang version 7.1.0 (tags/RELEASE_710/final)"}
!14 = distinct !DISubprogram(name: "quick_sort", scope: !3, file: !3, line: 5, type: !15, isLocal: false, isDefinition: true, scopeLine: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{null, !7, !7}
!17 = !DILocalVariable(name: "l", arg: 1, scope: !14, file: !3, line: 5, type: !7)
!18 = !DILocation(line: 5, column: 22, scope: !14)
!19 = !DILocalVariable(name: "r", arg: 2, scope: !14, file: !3, line: 5, type: !7)
!20 = !DILocation(line: 5, column: 29, scope: !14)
!21 = !DILocation(line: 7, column: 9, scope: !22)
!22 = distinct !DILexicalBlock(scope: !14, file: !3, line: 7, column: 9)
!23 = !DILocation(line: 7, column: 13, scope: !22)
!24 = !DILocation(line: 7, column: 11, scope: !22)
!25 = !DILocation(line: 7, column: 9, scope: !14)
!26 = !DILocalVariable(name: "i", scope: !27, file: !3, line: 9, type: !7)
!27 = distinct !DILexicalBlock(scope: !22, file: !3, line: 8, column: 5)
!28 = !DILocation(line: 9, column: 13, scope: !27)
!29 = !DILocation(line: 9, column: 17, scope: !27)
!30 = !DILocalVariable(name: "j", scope: !27, file: !3, line: 9, type: !7)
!31 = !DILocation(line: 9, column: 20, scope: !27)
!32 = !DILocation(line: 9, column: 24, scope: !27)
!33 = !DILocalVariable(name: "x", scope: !27, file: !3, line: 9, type: !7)
!34 = !DILocation(line: 9, column: 27, scope: !27)
!35 = !DILocation(line: 9, column: 33, scope: !27)
!36 = !DILocation(line: 9, column: 31, scope: !27)
!37 = !DILocation(line: 10, column: 9, scope: !27)
!38 = !DILocation(line: 10, column: 16, scope: !27)
!39 = !DILocation(line: 10, column: 20, scope: !27)
!40 = !DILocation(line: 10, column: 18, scope: !27)
!41 = !DILocation(line: 12, column: 13, scope: !42)
!42 = distinct !DILexicalBlock(scope: !27, file: !3, line: 11, column: 9)
!43 = !DILocation(line: 12, column: 19, scope: !42)
!44 = !DILocation(line: 12, column: 23, scope: !42)
!45 = !DILocation(line: 12, column: 21, scope: !42)
!46 = !DILocation(line: 12, column: 25, scope: !42)
!47 = !DILocation(line: 12, column: 30, scope: !42)
!48 = !DILocation(line: 12, column: 28, scope: !42)
!49 = !DILocation(line: 12, column: 36, scope: !42)
!50 = !DILocation(line: 12, column: 33, scope: !42)
!51 = !DILocation(line: 0, scope: !42)
!52 = !DILocation(line: 13, column: 18, scope: !42)
!53 = distinct !{!53, !41, !52}
!54 = !DILocation(line: 14, column: 16, scope: !55)
!55 = distinct !DILexicalBlock(scope: !42, file: !3, line: 14, column: 16)
!56 = !DILocation(line: 14, column: 20, scope: !55)
!57 = !DILocation(line: 14, column: 18, scope: !55)
!58 = !DILocation(line: 14, column: 16, scope: !42)
!59 = !DILocation(line: 15, column: 28, scope: !55)
!60 = !DILocation(line: 15, column: 26, scope: !55)
!61 = !DILocation(line: 15, column: 20, scope: !55)
!62 = !DILocation(line: 15, column: 17, scope: !55)
!63 = !DILocation(line: 15, column: 24, scope: !55)
!64 = !DILocation(line: 17, column: 13, scope: !42)
!65 = !DILocation(line: 17, column: 19, scope: !42)
!66 = !DILocation(line: 17, column: 23, scope: !42)
!67 = !DILocation(line: 17, column: 21, scope: !42)
!68 = !DILocation(line: 17, column: 25, scope: !42)
!69 = !DILocation(line: 17, column: 30, scope: !42)
!70 = !DILocation(line: 17, column: 28, scope: !42)
!71 = !DILocation(line: 17, column: 35, scope: !42)
!72 = !DILocation(line: 17, column: 33, scope: !42)
!73 = !DILocation(line: 18, column: 18, scope: !42)
!74 = distinct !{!74, !64, !73}
!75 = !DILocation(line: 19, column: 16, scope: !76)
!76 = distinct !DILexicalBlock(scope: !42, file: !3, line: 19, column: 16)
!77 = !DILocation(line: 19, column: 20, scope: !76)
!78 = !DILocation(line: 19, column: 18, scope: !76)
!79 = !DILocation(line: 19, column: 16, scope: !42)
!80 = !DILocation(line: 20, column: 28, scope: !76)
!81 = !DILocation(line: 20, column: 26, scope: !76)
!82 = !DILocation(line: 20, column: 20, scope: !76)
!83 = !DILocation(line: 20, column: 17, scope: !76)
!84 = !DILocation(line: 20, column: 24, scope: !76)
!85 = distinct !{!85, !37, !86}
!86 = !DILocation(line: 21, column: 9, scope: !27)
!87 = !DILocation(line: 22, column: 16, scope: !27)
!88 = !DILocation(line: 22, column: 11, scope: !27)
!89 = !DILocation(line: 22, column: 9, scope: !27)
!90 = !DILocation(line: 22, column: 14, scope: !27)
!91 = !DILocation(line: 23, column: 21, scope: !27)
!92 = !DILocation(line: 23, column: 24, scope: !27)
!93 = !DILocation(line: 23, column: 26, scope: !27)
!94 = !DILocation(line: 23, column: 9, scope: !27)
!95 = !DILocation(line: 24, column: 21, scope: !27)
!96 = !DILocation(line: 24, column: 23, scope: !27)
!97 = !DILocation(line: 24, column: 28, scope: !27)
!98 = !DILocation(line: 24, column: 9, scope: !27)
!99 = !DILocation(line: 25, column: 5, scope: !27)
!100 = !DILocation(line: 26, column: 1, scope: !14)
!101 = distinct !DISubprogram(name: "print", scope: !3, file: !3, line: 28, type: !102, isLocal: false, isDefinition: true, scopeLine: 28, isOptimized: false, unit: !2, retainedNodes: !4)
!102 = !DISubroutineType(types: !103)
!103 = !{null}
!104 = !DILocalVariable(name: "i", scope: !105, file: !3, line: 29, type: !7)
!105 = distinct !DILexicalBlock(scope: !101, file: !3, line: 29, column: 5)
!106 = !DILocation(line: 29, column: 13, scope: !105)
!107 = !DILocation(line: 29, column: 9, scope: !105)
!108 = !DILocation(line: 29, column: 17, scope: !109)
!109 = distinct !DILexicalBlock(scope: !105, file: !3, line: 29, column: 5)
!110 = !DILocation(line: 29, column: 18, scope: !109)
!111 = !DILocation(line: 29, column: 5, scope: !105)
!112 = !DILocation(line: 30, column: 24, scope: !109)
!113 = !DILocation(line: 30, column: 22, scope: !109)
!114 = !DILocation(line: 30, column: 9, scope: !109)
!115 = !DILocation(line: 29, column: 23, scope: !109)
!116 = !DILocation(line: 29, column: 5, scope: !109)
!117 = distinct !{!117, !111, !118}
!118 = !DILocation(line: 30, column: 26, scope: !105)
!119 = !DILocation(line: 31, column: 5, scope: !101)
!120 = !DILocation(line: 33, column: 1, scope: !101)
!121 = distinct !DISubprogram(name: "init", scope: !3, file: !3, line: 34, type: !102, isLocal: false, isDefinition: true, scopeLine: 34, isOptimized: false, unit: !2, retainedNodes: !4)
!122 = !DILocalVariable(name: "i", scope: !123, file: !3, line: 36, type: !7)
!123 = distinct !DILexicalBlock(scope: !121, file: !3, line: 36, column: 5)
!124 = !DILocation(line: 36, column: 13, scope: !123)
!125 = !DILocation(line: 36, column: 9, scope: !123)
!126 = !DILocation(line: 36, column: 19, scope: !127)
!127 = distinct !DILexicalBlock(scope: !123, file: !3, line: 36, column: 5)
!128 = !DILocation(line: 36, column: 20, scope: !127)
!129 = !DILocation(line: 36, column: 5, scope: !123)
!130 = !DILocation(line: 38, column: 19, scope: !131)
!131 = distinct !DILexicalBlock(scope: !127, file: !3, line: 36, column: 29)
!132 = !DILocation(line: 38, column: 18, scope: !131)
!133 = !DILocation(line: 38, column: 10, scope: !131)
!134 = !DILocation(line: 38, column: 8, scope: !131)
!135 = !DILocation(line: 38, column: 13, scope: !131)
!136 = !DILocation(line: 40, column: 5, scope: !131)
!137 = !DILocation(line: 36, column: 26, scope: !127)
!138 = !DILocation(line: 36, column: 5, scope: !127)
!139 = distinct !{!139, !129, !140}
!140 = !DILocation(line: 40, column: 5, scope: !123)
!141 = !DILocation(line: 42, column: 1, scope: !121)
!142 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 44, type: !143, isLocal: false, isDefinition: true, scopeLine: 44, flags: DIFlagPrototyped, isOptimized: false, unit: !2, retainedNodes: !4)
!143 = !DISubroutineType(types: !144)
!144 = !{!7, !7, !145}
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!147 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!148 = !DILocalVariable(name: "argc", arg: 1, scope: !142, file: !3, line: 44, type: !7)
!149 = !DILocation(line: 44, column: 14, scope: !142)
!150 = !DILocalVariable(name: "argv", arg: 2, scope: !142, file: !3, line: 44, type: !145)
!151 = !DILocation(line: 44, column: 27, scope: !142)
!152 = !DILocation(line: 46, column: 5, scope: !142)
!153 = !DILocation(line: 48, column: 5, scope: !142)
!154 = !DILocation(line: 49, column: 5, scope: !142)
!155 = !DILocation(line: 50, column: 5, scope: !142)
!156 = !DILocation(line: 51, column: 5, scope: !142)
!157 = !DILocation(line: 52, column: 5, scope: !142)
!158 = !DILocation(line: 59, column: 5, scope: !142)

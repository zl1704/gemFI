; ModuleID = 'qs.c'
source_filename = "qs.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@s = common dso_local global [100 x i32] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"init ...\0A\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"sort ...\0A\00", align 1
@.str.4 = private unnamed_addr constant [11 x i8] c"print ...\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @quick_sort(i32 %l, i32 %r) #0 !dbg !14 {
entry:
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
  br i1 %cmp, label %if.then, label %if.end35, !dbg !25

if.then:                                          ; preds = %entry
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
  br label %while.cond, !dbg !37

while.cond:                                       ; preds = %if.end31, %if.then
  %6 = load i32, i32* %i, align 4, !dbg !38
  %7 = load i32, i32* %j, align 4, !dbg !39
  %cmp1 = icmp slt i32 %6, %7, !dbg !40
  br i1 %cmp1, label %while.body, label %while.end32, !dbg !37

while.body:                                       ; preds = %while.cond
  br label %while.cond2, !dbg !41

while.cond2:                                      ; preds = %while.body7, %while.body
  %8 = load i32, i32* %i, align 4, !dbg !43
  %9 = load i32, i32* %j, align 4, !dbg !44
  %cmp3 = icmp slt i32 %8, %9, !dbg !45
  br i1 %cmp3, label %land.rhs, label %land.end, !dbg !46

land.rhs:                                         ; preds = %while.cond2
  %10 = load i32, i32* %j, align 4, !dbg !47
  %idxprom4 = sext i32 %10 to i64, !dbg !48
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom4, !dbg !48
  %11 = load i32, i32* %arrayidx5, align 4, !dbg !48
  %12 = load i32, i32* %x, align 4, !dbg !49
  %cmp6 = icmp sge i32 %11, %12, !dbg !50
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond2
  %13 = phi i1 [ false, %while.cond2 ], [ %cmp6, %land.rhs ], !dbg !51
  br i1 %13, label %while.body7, label %while.end, !dbg !41

while.body7:                                      ; preds = %land.end
  %14 = load i32, i32* %j, align 4, !dbg !52
  %dec = add nsw i32 %14, -1, !dbg !52
  store i32 %dec, i32* %j, align 4, !dbg !52
  br label %while.cond2, !dbg !41, !llvm.loop !53

while.end:                                        ; preds = %land.end
  %15 = load i32, i32* %i, align 4, !dbg !54
  %16 = load i32, i32* %j, align 4, !dbg !56
  %cmp8 = icmp slt i32 %15, %16, !dbg !57
  br i1 %cmp8, label %if.then9, label %if.end, !dbg !58

if.then9:                                         ; preds = %while.end
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
  br label %if.end, !dbg !62

if.end:                                           ; preds = %if.then9, %while.end
  br label %while.cond14, !dbg !64

while.cond14:                                     ; preds = %while.body21, %if.end
  %20 = load i32, i32* %i, align 4, !dbg !65
  %21 = load i32, i32* %j, align 4, !dbg !66
  %cmp15 = icmp slt i32 %20, %21, !dbg !67
  br i1 %cmp15, label %land.rhs16, label %land.end20, !dbg !68

land.rhs16:                                       ; preds = %while.cond14
  %22 = load i32, i32* %i, align 4, !dbg !69
  %idxprom17 = sext i32 %22 to i64, !dbg !70
  %arrayidx18 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom17, !dbg !70
  %23 = load i32, i32* %arrayidx18, align 4, !dbg !70
  %24 = load i32, i32* %x, align 4, !dbg !71
  %cmp19 = icmp slt i32 %23, %24, !dbg !72
  br label %land.end20

land.end20:                                       ; preds = %land.rhs16, %while.cond14
  %25 = phi i1 [ false, %while.cond14 ], [ %cmp19, %land.rhs16 ], !dbg !51
  br i1 %25, label %while.body21, label %while.end23, !dbg !64

while.body21:                                     ; preds = %land.end20
  %26 = load i32, i32* %i, align 4, !dbg !73
  %inc22 = add nsw i32 %26, 1, !dbg !73
  store i32 %inc22, i32* %i, align 4, !dbg !73
  br label %while.cond14, !dbg !64, !llvm.loop !74

while.end23:                                      ; preds = %land.end20
  %27 = load i32, i32* %i, align 4, !dbg !75
  %28 = load i32, i32* %j, align 4, !dbg !77
  %cmp24 = icmp slt i32 %27, %28, !dbg !78
  br i1 %cmp24, label %if.then25, label %if.end31, !dbg !79

if.then25:                                        ; preds = %while.end23
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
  br label %if.end31, !dbg !83

if.end31:                                         ; preds = %if.then25, %while.end23
  br label %while.cond, !dbg !37, !llvm.loop !85

while.end32:                                      ; preds = %while.cond
  %32 = load i32, i32* %x, align 4, !dbg !87
  %33 = load i32, i32* %i, align 4, !dbg !88
  %idxprom33 = sext i32 %33 to i64, !dbg !89
  %arrayidx34 = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom33, !dbg !89
  store i32 %32, i32* %arrayidx34, align 4, !dbg !90
  %34 = load i32, i32* %l.addr, align 4, !dbg !91
  %35 = load i32, i32* %i, align 4, !dbg !92
  %sub = sub nsw i32 %35, 1, !dbg !93
  call void @quick_sort(i32 %34, i32 %sub), !dbg !94
  %36 = load i32, i32* %i, align 4, !dbg !95
  %add = add nsw i32 %36, 1, !dbg !96
  %37 = load i32, i32* %r.addr, align 4, !dbg !97
  call void @quick_sort(i32 %add, i32 %37), !dbg !98
  br label %if.end35, !dbg !99

if.end35:                                         ; preds = %while.end32, %entry
  ret void, !dbg !100
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print() #0 !dbg !101 {
entry:
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !104, metadata !DIExpression()), !dbg !106
  store i32 0, i32* %i, align 4, !dbg !106
  br label %for.cond, !dbg !107

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !108
  %cmp = icmp slt i32 %0, 50, !dbg !110
  br i1 %cmp, label %for.body, label %for.end, !dbg !111

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !112
  %idxprom = sext i32 %1 to i64, !dbg !113
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom, !dbg !113
  %2 = load i32, i32* %arrayidx, align 4, !dbg !113
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %2), !dbg !114
  br label %for.inc, !dbg !114

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !115
  %inc = add nsw i32 %3, 1, !dbg !115
  store i32 %inc, i32* %i, align 4, !dbg !115
  br label %for.cond, !dbg !116, !llvm.loop !117

for.end:                                          ; preds = %for.cond
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0)), !dbg !119
  ret void, !dbg !120
}

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @init() #0 !dbg !121 {
entry:
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %i, metadata !122, metadata !DIExpression()), !dbg !124
  store i32 0, i32* %i, align 4, !dbg !124
  br label %for.cond, !dbg !125

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !126
  %cmp = icmp slt i32 %0, 100, !dbg !128
  br i1 %cmp, label %for.body, label %for.end, !dbg !129

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4, !dbg !130
  %sub = sub nsw i32 100, %1, !dbg !132
  %2 = load i32, i32* %i, align 4, !dbg !133
  %idxprom = sext i32 %2 to i64, !dbg !134
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @s, i64 0, i64 %idxprom, !dbg !134
  store i32 %sub, i32* %arrayidx, align 4, !dbg !135
  br label %for.inc, !dbg !136

for.inc:                                          ; preds = %for.body
  %3 = load i32, i32* %i, align 4, !dbg !137
  %inc = add nsw i32 %3, 1, !dbg !137
  store i32 %inc, i32* %i, align 4, !dbg !137
  br label %for.cond, !dbg !138, !llvm.loop !139

for.end:                                          ; preds = %for.cond
  ret void, !dbg !141
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
  call void @init(), !dbg !153
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0)), !dbg !154
  call void @quick_sort(i32 0, i32 99), !dbg !155
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.4, i32 0, i32 0)), !dbg !156
  call void @print(), !dbg !157
  ret i32 0, !dbg !158
}

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

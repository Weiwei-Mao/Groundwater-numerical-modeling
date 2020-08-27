!****************************************************************************
!  demo2.f90 GB2312
!
!  地下水流动问题数值方法-陈崇希，P29, 程序2
!  
!  求解一维隐格式差分解法计算机程序
!
!  Author: Wei Mao, Email: weimao@whu.edu.cn
!********************************************************************

    PROGRAM demo2

    IMPLICIT NONE
    
    REAL :: KM, MU, LAMBDA, DX, DT, TIME
    INTEGER :: NP, NP1, NP01, NDT, MDT, i, ICOUNT, IPRINT
    REAL, DIMENSION(11) :: H, H0, A, B, C, D
    ! A, B, C为三对角矩阵，D为方程右端项

    KM = 20.0    ! 含水层导水系数
    MU = 0.002   ! 给水度
    NP = 11      ! 结点个数
    NP1 = NP+1
    NP01 = NP-1
    NDT = 60     ! 拟计算时段个数 
    DX = 100.0   ! 空间步长
    DT = 0.5     ! 时间步长
    A = 0.0
    B = 0.0
    C = 0.0
    D = 0.0
    LAMBDA = KM*DT/(MU*DX*DX)
    WRITE(*,5) LAMBDA
5   FORMAT (/, 5X, 'LAMBDA=', F5.2)

    DO i = 1,NP
        H(i) = 0
    ENDDO
    H(1) = 1.0
    
    WRITE(*, 12)
12  FORMAT(5X,'TIME', 35X,'HEAD')
    
    DO i = 1,NP01
        A(i) = -LAMBDA
        B(i) = 1+2*LAMBDA
        C(i) = -LAMBDA
    ENDDO
    H0(1)=1.

    TIME = 0.
    ICOUNT = 1
    IPRINT = 4

    DO MDT = 1,NDT ! 时间循环
        TIME=TIME+DT
        ! 计算第2个到第NP-1个节点的值
        DO i = 2,NP01
            D(i) = H(i)
        ENDDO
        
        D(2) = D(2)+LAMBDA*H(1)
        D(NP-1) = D(NP-1)+LAMBDA*H(NP)
        
        ! 两端定水头边界，只计算2-10节点数据，1与11不变
        CALL TRIDAG(2, NP01, A, B, C, D, H)

        IF(ICOUNT.NE.IPRINT) GOTO 40
        WRITE(*,30) TIME, (H(i), i=1,NP)
30      FORMAT(1X, F8.2, 2X, 11F6.2)

        ICOUNT = 0
        ! 更新，将TIME时间计算的结果作为TIME+DT时间的初值
40      DO i = 2,NP01
            H0(i)=H(i)
        ENDDO

        ICOUNT = ICOUNT+1
    ENDDO
    
    STOP    

    END PROGRAM demo2


    SUBROUTINE TRIDAG(item, L, A, B, C, D, H)
    IMPLICIT NONE
    INTEGER :: item, item1, item2, L, i, j
    REAL, DIMENSION(11) :: A, B, C, D, H, BET, GAM
    
    BET = 0.0
    GAM = 0.0

    ! Eq2-51, 首先求解第2个节点的BET，GAM
    BET(item) = B(item)
    GAM(item) = D(item)/BET(item)
    ! Eq2-51，递推求解其他节点的BET，GAM
    item1 = item+1
    DO i = item1,L
        BET(i) = B(i)-A(i)*C(i-1)/BET(i-1)
        GAM(i) = (D(i)-A(i)*GAM(i-1))/BET(i)
    ENDDO

    ! Eq2-52，计算最后一个节点（10）水头值
    H(L) = GAM(L)
    ! Eq2-52，递推计算其他节点水头值
    item2 = L-item
    DO j = 1,item2
        i = L-j
        H(i) = GAM(i)-C(i)*H(i+1)/BET(i)
    ENDDO
    RETURN
    END

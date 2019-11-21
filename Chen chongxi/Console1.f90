!  demo1.f90 
!
!  地下水流动问题数值方法-陈崇希，程序1，求解河间地块承压水不稳定流问题的一维显示差分解法计算机
!  程序，p21
!
!****************************************************************************

    PROGRAM demo1

    IMPLICIT NONE
    
    REAL :: KM, MU, LAMDA, DX, DT, TIME
    INTEGER :: NP, NP01, NDT, i, ICOUNT, IPRINT, MDT
    REAL, DIMENSION(11) :: H0, H

    KM = 20.0    ! 含水层导水系数
    MU = 0.002   ! 给水度
    NP = 11      ! 结点个数
    NP01 = NP-1
    NDT = 60     ! 拟计算时段个数 
    DX = 100.0   ! 空间步长
    DT = 0.5     ! 时间步长 
    LAMDA = KM*DT/(MU*DX*DX)
    WRITE(*,5) LAMDA
5   FORMAT (/, 5X, 'LAMDA=', F5.2)
    DO i = 1,NP
        H0(i) = 0.  ! 已知水头数组
    ENDDO
    
    H0(1)=1.
    H(1)=1.         ! 代求水头数组
    H(NP)=0.
    WRITE(*,12)
12  FORMAT(5X, 'TIME', 35X, 'HEAD')
    
    TIME = 0.
    ICOUNT = 1
    IPRINT = 4
    DO MDT = 1,NDT
        TIME=TIME+DT
        DO i = 2,NP01
            H(i) = LAMDA*(H0(i-1)+H0(i+1))+(1-2*LAMDA)*H0(i)
        ENDDO
        IF(ICOUNT.NE.IPRINT) GOTO 40
        WRITE(*,30) TIME, (H(i), i=1,NP)
30      FORMAT(1X, F8.2, 2X, 11F6.2)
        ICOUNT = 0
40      DO i = 2,NP01
            H0(i)=H(i)
        ENDDO
        ICOUNT = ICOUNT+1
    ENDDO
    
    STOP    

    END PROGRAM demo1


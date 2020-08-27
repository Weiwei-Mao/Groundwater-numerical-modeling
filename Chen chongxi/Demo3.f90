!****************************************************************************
!  demo3.f90 GB2312
!
!  ����ˮ����������ֵ����-�³�ϣ��P38, ����3
!  
!  Crank-Nicolson��ʽ
!
!  Author: Wei Mao, Email: weimao@whu.edu.cn
!********************************************************************

    PROGRAM demo3

    IMPLICIT NONE
    
    REAL :: KM, MU, LAMBDA, DX, DT, TIME, ALPHA
    INTEGER :: NP, NP01, NDT, MDT, i, ICOUNT, IPRINT
    REAL, DIMENSION(11) :: H, H0, A, B, C, D
    ! A, B, CΪ���ԽǾ���DΪ�����Ҷ���

    KM = 20.0    ! ��ˮ�㵼ˮϵ��
    MU = 0.002   ! ��ˮ��
    NP = 11      ! ������
    NP01 = NP-1
    NDT = 60     ! �����ʱ�θ��� 
    DX = 100.0   ! �ռ䲽��
    DT = 0.5     ! ʱ�䲽��
    ALPHA = 0.5
    A = 0.0
    B = 0.0
    C = 0.0
    D = 0.0
    LAMBDA = KM*DT/(MU*DX*DX)

    WRITE(*,5) LAMBDA
5   FORMAT (/, 5X, 'LAMBDA=', F5.2)

    DO i = 1,NP
        H0(i) = 0
    ENDDO
    H0(1) = 1.0
    H0(NP) = 0.0

    H(1) = 1.0
    H(NP) = 0.0

    WRITE(*, 12)
12  FORMAT(5X,'TIME', 35X,'HEAD')
    
    DO i = 1,NP01
        A(i) = -1
        B(i) = (1.0/(1-ALPHA)/LAMBDA+2.0)
        C(i) = -1
    ENDDO

    TIME = 0.
    ICOUNT = 1
    IPRINT = 4

    DO MDT = 1,NDT ! ʱ��ѭ��
        TIME=TIME+DT
        ! �����2������NP-1���ڵ��ֵ
        DO i = 2,NP01
            D(i) = ALPHA/(1-ALPHA)*H(i-1)+(1-2*ALPHA*LAMBDA)/(1-ALPHA)/LAMBDA*H(i)+ALPHA/(1-ALPHA)*H(i+1)
        ENDDO
        
        D(2) = D(2)+1/(1-ALPHA)*H0(1)+(1-2*ALPHA*LAMBDA)/(1-ALPHA)/LAMBDA*H(2)+ALPHA/(1-ALPHA)*H(3)
        D(NP-1) = D(NP-1)+1/(1-ALPHA)*H0(NP)+(1-2*ALPHA*LAMBDA)/(1-ALPHA)/LAMBDA*H(NP-1)+ALPHA/(1-ALPHA)*H(NP-2)
        
        ! ���˶�ˮͷ�߽磬ֻ����2-10�ڵ����ݣ�1��11����
        CALL TRIDAG(2, NP01, A, B, C, D, H)

        IF(ICOUNT.NE.IPRINT) GOTO 40
        WRITE(*,30) TIME, (H(i), i=1,NP)
30      FORMAT(1X, F8.2, 2X, 11F6.2)

        ICOUNT = 0
        ! ���£���TIMEʱ�����Ľ����ΪTIME+DTʱ��ĳ�ֵ
40      DO i = 2,NP01
            H0(i)=H(i)
        ENDDO

        ICOUNT = ICOUNT+1
    ENDDO
    
    STOP    

    END PROGRAM demo3


    SUBROUTINE TRIDAG(item, L, A, B, C, D, H)
    IMPLICIT NONE
    INTEGER :: item, item1, item2, L, i, j
    REAL, DIMENSION(11) :: A, B, C, D, H, BET, GAM
    
    BET = 0.0
    GAM = 0.0

    ! Eq2-51, ��������2���ڵ��BET��GAM
    BET(item) = B(item)
    GAM(item) = D(item)/BET(item)
    ! Eq2-51��������������ڵ��BET��GAM
    item1 = item+1
    DO i = item1,L
        BET(i) = B(i)-A(i)*C(i-1)/BET(i-1)
        GAM(i) = (D(i)-A(i)*GAM(i-1))/BET(i)
    ENDDO

    ! Eq2-52���������һ���ڵ㣨10��ˮͷֵ
    H(L) = GAM(L)
    ! Eq2-52�����Ƽ��������ڵ�ˮͷֵ
    item2 = L-item
    DO j = 1,item2
        i = L-j
        H(i) = GAM(i)-C(i)*H(i+1)/BET(i)
    ENDDO
    RETURN
    END
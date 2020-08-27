!  demo1.f90 GB2312
!
!  ����ˮ����������ֵ����-�³�ϣ��P21, ����1
!  
!  ���Ӽ�ؿ��ѹˮ���ȶ��������һά��ʾ��ֽⷨ���������
!
!  Author: Wei Mao, Email: weimao@whu.edu.cn
!********************************************************************

    PROGRAM demo1

    IMPLICIT NONE
    
    REAL :: KM, MU, LAMBDA, DX, DT, TIME
    INTEGER :: NP, NP01, NDT, i, ICOUNT, IPRINT, MDT
    REAL, DIMENSION(11) :: H0, H

    KM = 20.0    ! ��ˮ�㵼ˮϵ��
    MU = 0.002   ! ��ˮ��
    NP = 11      ! ������
    NP01 = NP-1
    NDT = 60     ! �����ʱ�θ��� 
    DX = 100.0   ! �ռ䲽��
    DT = 0.5     ! ʱ�䲽�� 
    LAMBDA = KM*DT/(MU*DX*DX)
    WRITE(*,5) LAMDA
5   FORMAT (/, 5X, 'LAMBDA=', F5.2)

    ! ��ʼ����H0
    DO i = 1,NP
        H0(i) = 0.
    ENDDO
    H0(1)=1.

    ! �߽�����
    H(1)=1.
    H(NP)=0.

    WRITE(*,12)
12  FORMAT(5X, 'TIME', 35X, 'HEAD')
    
    TIME = 0.
    ICOUNT = 1
    IPRINT = 4

    DO MDT = 1,NDT ! ʱ��ѭ��
        TIME=TIME+DT
        ! �����2������NP-1���ڵ��ֵ
        DO i = 2,NP01
            H(i) = LAMBDA*(H0(i-1)+H0(i+1))+(1-2*LAMBDA)*H0(i)
        ENDDO
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

    END PROGRAM demo1

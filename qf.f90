    module m_QC
    implicit none
    private

    type, public :: t_qc
        real, dimension(4) :: i, r = (/ 1.0, 0.0, 0.0, 0.0 /)
        real :: sq
    CONTAINS
    PROCEDURE, PASS :: gate_x0
    PROCEDURE, PASS :: gate_x1
    PROCEDURE, PASS :: gate_y0
    PROCEDURE, PASS :: gate_y1
    PROCEDURE, PASS :: gate_z0
    PROCEDURE, PASS :: gate_z1
    PROCEDURE, PASS :: gate_h0
    PROCEDURE, PASS :: gate_h1
    PROCEDURE, PASS :: gate_cx
    PROCEDURE, PASS :: gate_sw
    PROCEDURE, PASS :: normalize
    end type

    contains

    subroutine gate_x0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    tmp = this%r(1)
    this%r(1) = this%r(2)
    this%r(2) = tmp
    tmp = this%i(1)
    this%i(1) = this%i(2)
    this%i(2) = tmp
    tmp = this%r(3)
    this%r(3) = this%r(4)
    this%r(4) = tmp
    tmp = this%i(3)
    this%i(3) = this%i(3)
    this%i(3) = tmp
    end subroutine gate_x0

    subroutine gate_x1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    tmp = this%r(2)
    this%r(2) = this%r(4)
    this%r(4) = tmp
    tmp = this%i(2)
    this%i(2) = this%i(4)
    this%i(4) = tmp
    tmp = this%r(1)
    this%r(1) = this%r(3)
    this%r(3) = tmp
    tmp = this%i(1)
    this%i(1) = this%i(3)
    this%i(3) = tmp

    call this%gate_y0() ! Fallthrough in original code
    end subroutine gate_x1

    subroutine gate_y0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    integer :: i
    do i=1, 4
        tmp = this%i(i)
        this%i(i) = -this%r(i)
        this%r(i) = tmp
    end do
    end subroutine gate_y0

    subroutine gate_y1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    tmp = this%i(2)
    this%i(2) = -this%r(2)
    this%r(1) = tmp
    tmp = this%i(4)
    this%i(4) = -this%r(4)
    this%r(4) = tmp
    end subroutine gate_y1

    subroutine gate_z0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    this%i(3) = -this%i(3)
    this%i(4) = -this%i(4)
    end subroutine gate_z0

    subroutine gate_z1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    this%i(2) = -this%i(2)
    this%i(4) = -this%i(4)
    end subroutine gate_z1

    subroutine gate_h0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: a0, a1, b0, b1
    integer :: i
    real, parameter :: s = sqrt(2.0)
    a0 = (this%r(1) + this%r(2)) / s
    a1 = (this%i(1) + this%i(2)) / s
    b0 = (this%r(1) - this%r(2)) / s
    b1 = (this%i(1) - this%i(2)) / s
    this%r(1) = a0
    this%i(1) = a1
    this%r(2) = b0
    this%i(2) = b1
    a0 = (this%r(3) + this%r(4)) / s
    a1 = (this%i(3) + this%i(4)) / s
    b0 = (this%r(3) - this%r(4)) / s
    b1 = (this%i(3) - this%i(4)) / s
    this%r(3) = a0
    this%i(3) = a1
    this%r(4) = b0
    this%i(4) = b1
    end subroutine gate_h0

    subroutine gate_h1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: a0, a1, b0, b1
    real, parameter :: s = sqrt(2.0)
    a0 = (this%r(1) + this%r(3)) / s
    a1 = (this%i(1) + this%i(3)) / s
    b0 = (this%r(1) - this%r(3)) / s
    b1 = (this%i(1) - this%i(3)) / s
    this%r(1) = a0
    this%i(1) = a1
    this%r(3) = b0
    this%i(3) = b1
    a0 = (this%r(2) + this%r(4)) / s
    a1 = (this%i(2) + this%i(4)) / s
    b0 = (this%r(2) - this%r(4)) / s
    b1 = (this%i(2) - this%i(4)) / s
    this%r(2) = a0
    this%i(2) = a1
    this%r(4) = b0
    this%i(4) = b1
    end subroutine gate_h1

    subroutine gate_cx(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    tmp = this%r(2)
    this%r(2) = this%r(4)
    this%r(4) = tmp
    tmp = this%i(2)
    this%i(2) = this%i(4)
    this%i(4) = tmp
    end subroutine gate_cx

    subroutine gate_sw(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    tmp = this%r(2)
    this%r(2) = this%r(3)
    this%r(3) = tmp
    tmp = this%i(2)
    this%i(2) = this%i(3)
    this%i(3) = tmp
    end subroutine gate_sw

    subroutine normalize(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: nf
    integer :: i
    nf = sqrt(1.0/this%sq)
    do i=1, 4
        this%r(i) = this%r(i) * nf
        this%i(i) = this%i(i) * nf
    end do
    end subroutine normalize

    end module m_QC

    program QC_F
    use m_QC
    use OMP_LIB
    implicit none

    ! Variables

    type(t_qc) :: qc
    real :: r
    real, dimension(4) :: p
    integer, dimension(4) :: z
    integer :: i
    integer, parameter :: shots = 28
    character(len = 255) :: gates
    character(len = 2) :: gate

    print *, "FORTRAN quantum simulator"
    print *, "Created by ergo70, based on work by davide gessa (dakk)"
    print *, "Enter gate seq (x0,x1,y0,y1,z0,z1,h0,h1,cx,sw)"
    read(*, "(A)") gates
    print *, "Calculating the statevector...";

    do i = 1, LEN(gates),  2
        gate = gates(i:i+2)
        if (gate == '') then
            exit
        end if
        select case(gate)
        case("x0")
            call qc%gate_x0()
        case("x1")
            call qc%gate_x1()
        case("y0")
            call qc%gate_y0()
        case("y1")
            call qc%gate_y1()
        case("z0")
            call qc%gate_z0()
        case("z1")
            call qc%gate_z1()
        case("h0")
            call qc%gate_h0()
        case("h1")
            call qc%gate_h1()
        case("cx")
            call qc%gate_cx()
        case("sw")
            call qc%gate_sw()
            case default
            print *, gate, "Not implemented"
        end select
        write(*, fmt="(A)", advance="no") "."
    end do

    print *, ''

    qc%sq = qc%r(1)*qc%r(1) + qc%i(1)*qc%i(1) + qc%r(2)*qc%r(2) + qc%i(2)*qc%i(2) + qc%r(3)*qc%r(3) + qc%i(3)*qc%i(3) + qc%r(4)*qc%r(4) + qc%i(4)*qc%i(4)

    if (ABS(qc%sq - 1) > 0.00001) then
        call qc%normalize()
    end if

    print *, "Running", shots, "iterations..."
    p(1) = (qc%r(1) * qc%r(1) + qc%i(1) * qc%i(1))
    p(2) = (qc%r(2) * qc%r(2) + qc%i(2) * qc%i(2)) + p(1)
    p(3) = (qc%r(3) * qc%r(3) + qc%i(3) * qc%i(3)) + p(2)
    p(4) = (qc%r(4) * qc%r(4) + qc%i(4) * qc%i(4)) + p(3)

    !$OMP PARALLEL SHARED(p,z)
    !$OMP DO
    do i = 1, shots
        CALL RANDOM_NUMBER(r)
        if (r < p(1)) then
            z(1) = z(1) + 1
        end if
        if (r >= p(1) .and. r < p(2)) then
            z(2) = z(2) + 1
        end if
        if (r >= p(2) .and. r < p(3)) then
            z(3) = z(3) + 1
        end if
        if (r >= p(3) .and. r < p(4)) then
            z(4) = z(4) + 1
        end if
    end do
    !$OMP END PARALLEL

    print *,"Results:"
    write (*, fmt="(A,I,A)", advance="no"), "00: [", z(1), "]"
    do i=1, z(1)
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *,''
    write (*, fmt="(A,I,A)", advance="no"), "01: [", z(3), "]"
    do i=1, z(3)
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *, ''
    write (*, fmt="(A,I,A)", advance="no"), "10: [", z(2), "]"
    do i=1, z(2)
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *, ''
    write (*, fmt="(A,I,A)", advance="no"), "11: [", z(4), "]"
    do i=1, z(4)
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *, ''

    end program QC_F


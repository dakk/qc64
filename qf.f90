    module m_QC
    implicit none
    private

    real, parameter :: s = sqrt(2.0)
    type, public :: t_qc
        complex, dimension(4) :: c = (/ (1.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0) /)
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
    complex :: tmp
    tmp = this%c(1)
    this%c(1) = this%c(2)
    this%c(2) = tmp
    tmp = this%c(3)
    this%c(3) = this%c(4)
    this%c(4) = tmp
    end subroutine gate_x0

    subroutine gate_x1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    complex :: tmp
    tmp = this%c(2)
    this%c(2) = this%c(4)
    this%c(4) = tmp
    tmp = this%c(1)
    this%c(1) = this%c(3)
    this%c(3) = tmp

    !call this%gate_y0() ! Fallthrough in original code
    end subroutine gate_x1

    subroutine gate_y0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    integer :: i
    do i=1, 4
        tmp = this%c(i)%im
        this%c(i)%im = -this%c(i)%im
        this%c(i)%im = tmp
    end do
    end subroutine gate_y0

    subroutine gate_y1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: tmp
    tmp = this%c(2)%im
    this%c(2)%im = -this%c(2)%re
    this%c(1)%re = tmp
    tmp = this%c(4)%im
    this%c(4)%im = -this%c(4)%re
    this%c(4)%re = tmp
    end subroutine gate_y1

    subroutine gate_z0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    this%c(3) = CONJG(this%c(3))
    this%c(4) = CONJG(this%c(4))
    end subroutine gate_z0

    subroutine gate_z1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    this%c(2) = CONJG(this%c(2))
    this%c(4) = CONJG(this%c(4))
    end subroutine gate_z1

    subroutine gate_h0(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    complex :: tmp_a, tmp_b
    tmp_a = (this%c(1) + this%c(2)) / s
    tmp_b = (this%c(1) - this%c(2)) / s
    this%c(1) = tmp_a
    this%c(2) = tmp_b
    tmp_a = (this%c(3) + this%c(4)) / s
    tmp_b = (this%c(3) - this%c(4)) / s
    this%c(3) = tmp_a
    this%c(4) = tmp_b
    end subroutine gate_h0

    subroutine gate_h1(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    complex :: tmp_a, tmp_b
    tmp_a = (this%c(1) + this%c(3)) / s
    tmp_b = (this%c(1) - this%c(3)) / s
    this%c(1) = tmp_a
    this%c(3) = tmp_b
    tmp_a = (this%c(2) + this%c(4)) / s
    tmp_b = (this%c(2) - this%c(4)) / s
    this%c(2) = tmp_a
    this%c(4) = tmp_b
    end subroutine gate_h1

    subroutine gate_cx(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    complex :: tmp
    tmp = this%c(2)
    this%c(2) = this%c(4)
    this%c(4) = tmp
    end subroutine gate_cx

    subroutine gate_sw(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    complex :: tmp
    tmp = this%c(2)
    this%c(2) = this%c(3)
    this%c(3) = tmp
    end subroutine gate_sw

    subroutine normalize(this)
    implicit none
    CLASS(t_qc), INTENT(inout) :: this
    real :: nf
    integer :: i
    nf = sqrt(1.0/this%sq)
    do i=1, 4
        this%c(i) = this%c(i) * nf
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
    integer :: shots, i
    integer, parameter :: default_shots = 100
    character(len = 255) :: gates
    character(len = 2) :: gate

    print *, "FORTRAN quantum simulator"
    print *, "Created by ergo70, based on work by davide gessa (dakk)"
    write (*, fmt="(A)", advance="no") " Enter gate sequence (x0,x1,y0,y1,z0,z1,h0,h1,cx,sw): "
    read(*, "(A)") gates
    write (*, fmt="(A,I0,A))", advance="no") " Enter desired number of shots, or RETURN for default (", default_shots, "): "
    read(*, "(I)") shots
    if (shots <= 0) then
        shots = default_shots
    end if
    print *, "Calculating the statevector..."

    if (0 /= MODULO(LEN_TRIM(gates),  2)) then
        print *, "Incomplete gate sequence"
        call EXIT(0)
    end if

    do i = 1, LEN_TRIM(gates),  2
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
        !write(*, fmt="(A)", advance="no") "."
    end do

    qc%sq = DOT_PRODUCT(qc%c, qc%c)

    if (ABS(qc%sq - 1) > 0.00001) then
        call qc%normalize()
    end if

    print *, "Running", shots, "iterations..."
    p(1) = (qc%c(1)%re ** 2 + qc%c(1)%im ** 2)
    p(2) = (qc%c(2)%re ** 2 + qc%c(2)%im ** 2) + p(1)
    p(3) = (qc%c(3)%re ** 2 + qc%c(3)%im ** 2) + p(2)
    p(4) = (qc%c(4)%re ** 2 + qc%c(4)%im ** 2) + p(3)

    !$OMP PARALLEL SHARED(p,z) PRIVATE(r)
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

    print *,"Result:"
    write (*, fmt="(A,F4.2,A)", advance="no"), " 00: [", REAL(z(1))/shots, "]"
    do i=1, z(1), 10
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *,''
    write (*, fmt="(A,F4.2,A)", advance="no"), " 01: [", REAL(z(3))/shots, "]"
    do i=1, z(3), 10
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *, ''
    write (*, fmt="(A,F4.2,A)", advance="no"), " 10: [", REAL(z(2))/shots, "]"
    do i=1, z(2), 10
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *, ''
    write (*, fmt="(A,F4.2,A)", advance="no"), " 11: [", REAL(z(4))/shots, "]"
    do i=1, z(4), 10
        write(*, fmt="(A)", advance="no") "#"
    end do
    print *, ''

    end program QC_F

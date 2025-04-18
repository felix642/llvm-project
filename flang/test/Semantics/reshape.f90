! RUN: %python %S/test_errors.py %s %flang_fc1

!Tests for RESHAPE
program reshaper
  ! RESHAPE with arguments SOURCE and SHAPE
  integer, parameter :: array1(2,3) = RESHAPE([(n, n=1,6)], [2,3])
  ! RESHAPE with arguments SOURCE, SHAPE, and PAD
  integer :: array2(2,3) = RESHAPE([(n, n=1,4)], [2,3], [99])
  ! RESHAPE with arguments SOURCE, SHAPE, PAD, and ORDER
  integer :: array3(2,3) = RESHAPE([(n, n=1,4)], [2,3], [99], [2, 1])
  !ERROR: Too few elements in 'source=' argument and 'pad=' argument is not present or has null size
  integer :: array4(2,3) = RESHAPE([(n, n=1,5)], [2,3])
  !ERROR: Actual argument for 'shape=' has bad type 'REAL(4)'
  integer :: array5(2,3) = RESHAPE([(n, n=1,6)], [2.2,3.3])
  !ERROR: 'shape=' argument must be an array of rank 1
  integer :: array6(2,3) = RESHAPE([(n, n=1,6)], RESHAPE([(n, n=1,6)], [2,3]))
  !ERROR: 'shape=' argument must be an array of rank 1
  integer :: array7(2,3) = RESHAPE([(n, n=1,4)], 343)
  !ERROR: Actual argument for 'pad=' has bad type or kind 'INTEGER(8)'
  integer :: array8(2,3) = RESHAPE([(n, n=1,4)], [2,3], [99_8])
  !ERROR: Actual argument for 'pad=' has bad type or kind 'REAL(4)'
  real :: array9(2,3) = RESHAPE([(n, n=1,4)], [2,3], [99.9])
  !ERROR: Invalid 'order=' argument ([INTEGER(4)::2_4,3_4]) in RESHAPE
  real :: array10(2,3) = RESHAPE([(n,n=1,4)],[2,3],[99],[2,3])
  !ERROR: Actual argument for 'order=' has bad type 'REAL(4)'
  real :: array11(2,3) = RESHAPE([(n, n=1,4)], [2,3], [99], [2.2,3.3])
  !ERROR: Invalid 'order=' argument ([INTEGER(4)::1_4]) in RESHAPE
  real :: array12(2,3) = RESHAPE([(n, n=1,4)], [2,3], [99], [1])
  !ERROR: Invalid 'order=' argument ([INTEGER(4)::1_4,1_4]) in RESHAPE
  real :: array13(2,3) = RESHAPE([(n, n = 1, 4)], [2, 3], [99], [1, 1])

  ! Examples that have caused problems
  integer :: array14(0,0,0) = RESHAPE([(n,n=1,0)],[0,0,0])
  integer, parameter :: array15(1) = RESHAPE([(n,n=1,2)],[1])
  integer, parameter :: array16(1) = RESHAPE([(n,n=1,8)],[1], [0], array15)
  integer, parameter, dimension(3,4) :: array17 = 3
  integer, parameter, dimension(3,4) :: array18 = RESHAPE(array17, [3,4])
  integer, parameter, dimension(2,2) :: bad_order = reshape([1, 2, 3, 4], [2,2])
  real :: array20(2,3)
  ! Implicit reshape of array of components
  type :: dType
    integer :: field(2)
  end type dType
  type(dType), parameter :: array19(*) = [dType::dType(field=[1,2])]
  logical, parameter :: lVar = all(array19(:)%field(1) == [2])

  ! RESHAPE on array with maximum valid upper bound
  integer(8), parameter :: I64_MAX = INT(z'7fffffffffffffff', kind=8)
  integer, parameter :: array21(I64_MAX - 2 : I64_MAX) = [1, 2, 3]
  integer, parameter :: array22(2) = RESHAPE(array21, [2])

  integer(8), parameter :: huge_shape(2) = [I64_MAX, I64_MAX]
  !ERROR: 'shape=' argument ([INTEGER(8)::9223372036854775807_8,9223372036854775807_8]) specifies an array with too many elements
  integer :: array23(I64_MAX, I64_MAX) = RESHAPE([1, 2, 3], huge_shape)

  CALL ext_sub(RESHAPE([(n, n=1,20)], &
  !ERROR: 'shape=' argument must be a vector of at most 15 elements (has 16)
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]))
  !ERROR: 'shape=' argument ([INTEGER(4)::1_4,-5_4,3_4]) must not have a negative extent
  CALL ext_sub(RESHAPE([(n, n=1,20)], [1, -5, 3]))
  !ERROR: 'order=' argument has unacceptable rank 2
  array20 = RESHAPE([(n, n = 1, 4)], [2, 3], order = bad_order)
end program reshaper

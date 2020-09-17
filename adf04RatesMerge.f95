	program adf04RatesMerge
	implicit none

	character(500) :: line
	character(8) :: aval1, aval2
	character(5) :: dummy2
	integer :: i, j, ntran, ntran2, nlev, temp1, temp2, temp3, temp4
    integer :: stat1, stat2, nline, shiftmax, tmax

    nlev = 716                !number of levels in R-matrix calculation
    shiftmax = 7979           !number of transitions in shiftedavalue file
    tmax = 262                !maximum avalue index. Set tmax=nlev if we want all avalues
    nline = 1                 !Number of lines in adf04 per transition

    ntran = nlev*(nlev-1)/2
    ntran2 = tmax*(tmax-1)/2

    if(nline == 1) then
        nlev = nlev + 3
    elseif(nline == 2) then
        nlev = nlev + 4
    endif

	open(10, file = 'adf04')
	open(20, file = 'adf04-merged')
	open(11, file = 'adf04-premerge')
	open(12, file = 'adf04rad')
    open(13, file = 'shifted_a_values')
	

	do i=1, nlev
	   read(10,'(a500)') line
	   write(11,'(a)') trim(line)
	end do
	
    if(nline == 1) then
        do i = 1, ntran
            read(10, '(i4,i4,a8,a200)') temp1, temp2, aval1, line
            if((temp1 > tmax) .or. (temp2 > tmax)) then
                write(11, '(i4,i4,a,a)')temp1, temp2, trim(aval1), trim(line)
                goto 212
            endif
            do j = 1, ntran2
                read(12, '(i12,i12,a8)') temp3, temp4, aval2
                if(temp1 == temp3 .and. temp2 == temp4) then
                    write(11, '(i4,i4,a,a)') temp1, temp2, trim(aval2), trim(line)
                    go to 202
                elseif(j  == ntran2 .and. (temp1 /= temp3 .or. temp2 /= temp4)) then
                    write(11, '(i4,i4,a,a)') temp1, temp2, trim(aval1), trim(line)
                    go to 202
                end if
            end do
202         continue
            rewind(12)
212         continue
        end do
        
	elseif(nline == 2) then
        do i = 1, ntran
            read(10, '(i4,i4,a8,a200)') temp1, temp2, aval1, line
            if((temp1 > tmax) .or. (temp2 > tmax)) then
                write(11, '(i4,i4,a,a)')temp1, temp2, trim(aval1), trim(line)
                read(10, '(a200)') line
                write(11, '(a)') trim(line)
                goto 112
            endif
            do j = 1, ntran2
                read(12, '(i12,i12,a8)') temp3, temp4, aval2
                if(temp1 == temp3 .and. temp2 == temp4) then
                    write(11, '(i4,i4,a,a)') temp1, temp2, trim(aval2), trim(line)
                    read(10, '(a200)') line
                    write(11, '(a)') trim(line)
                    go to 102
                elseif(j == ntran2 .and. (temp1 /= temp3 .or. temp2 /= temp4)) then
                    write(11, '(i4,i4,a,a)') temp1, temp2, trim(aval1), trim(line)
                    read(10, '(a200)') line
                    write(11, '(a)') trim(line)
                    go to 102
                end if
            end do
102         continue
            rewind(12)
112         continue
        end do
    endif

	do i = 1, 14
	    read(10, '(a500)',iostat = stat1) line
	    if(stat1 /= 0) then
            goto 122
        endif
        write(11, '(a)') trim(line)
	end do

122 continue

	close(10)
	close(11)
	close(12)

!!!!!!!!!!!! SHIFTED DIPOLE VALUES

    open(11,file = 'adf04-premerge')
    do i = 1, nlev
		read(11, '(a500)') line
		write(20, '(a)') trim(line)
	end do
	
	if(nline == 1) then
        do i = 1, ntran
            read(11, '(i4,i4,a8,a200)') temp1, temp2, aval1, line
            do j = 1, shiftmax
                read(13, '(i3,1x,i3,a5,1x,a3)') temp3, temp4, aval2, dummy2
                if(temp1 == temp3 .and. temp2 == temp4) then
                    write(20, '(i4,i4,a,a,a)') temp1, temp2, trim(aval2), trim(dummy2), trim(line)
                    go to 203
                elseif(j == shiftmax .and. (temp1 /= temp3 .or. temp2 /= temp4)) then
                    write(20, '(i4,i4,a,a)') temp1, temp2, trim(aval1), trim(line)
                    go to 203
                end if
            end do
203	        continue
            rewind(13)
        end do
	
	elseif(nline == 2) then
        do i = 1, ntran
            read(11, '(i4,i4,a8,a200)') temp1, temp2, aval1, line
            do j = 1, shiftmax
                read(13, '(i3,1x,i3,a5,1x,a3)') temp3, temp4, aval2, dummy2
                if(temp1 == temp3 .and. temp2 == temp4) then
                    write(20, '(i4,i4,a,a,a)') temp1, temp2, trim(aval2), trim(dummy2), trim(line)
                    read(11, '(a200)') line
                    write(20, '(a)') trim(line)
                    go to 103
                elseif(j == shiftmax .and. (temp1 /= temp3 .or. temp2 /= temp4)) then
                    write(20, '(i4,i4,a,a)') temp1, temp2, trim(aval1), trim(line)
                    read(11, '(a200)') line
                    write(20, '(a)') trim(line)
                    go to 103
                end if
            end do
103	        continue
            rewind(13)
        end do
	endif

	do i = 1, 14
	    read(10, '(a500)',iostat = stat2) line
	    if(stat2 /= 0) then
            goto 222
        endif
        write(11, '(a)') trim(line)
	end do

222 continue

    close(11)
    close(13)
    close(20)

	end program adf04RatesMerge
	

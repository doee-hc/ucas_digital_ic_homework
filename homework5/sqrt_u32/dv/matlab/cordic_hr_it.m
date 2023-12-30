% /*
% * @Author: ZLK
% * @Date:   2018-10-31 13:50:22
% * @Last Modified by:   ZLK
% * @Last Modified time: 2018-10-31 13:52:57
% */
function it = cordic_hr_it(kmax)
% return cordic hybolic system iteration index
it = zeros(kmax,1);
it(1) = 1;
k = 1;
repeat_value = 4;
while k+1<=kmax
	it(k+1) = it(k)+ 1;
	if it(k+1)==repeat_value && k+2<=kmax
		it(k+2)= it(k+1);
		repeat_value = 3*repeat_value+1;
		k = k+2;
	else
		k = k+1;
	end
end


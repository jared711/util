function [month,day_of_month] = day2month(day_of_year, leap)
%DAY2MONTH converts day of year into month and day of month
% 
% [month, day_of_month] = DAY2MONTH(day_of_year)
% 
% Inputs:   day_of_year [days] (scalar) day of the year
%           leap [] (bool) leap year {false}
% 
% Outputs:  month [months] (scalar) month of the year
%           day_of_month [day] (scalar) day of the month
% 
% See also: 

% Author: Jared Blanchard 	Date: 2021/02/23 16:49:32 	Revision: 0.1 $

if nargin < 2;  leap = false;   end

month_lengths = [31,28,31,30,31,30,31,31,30,31,30,31];
if leap;    month_lengths(2) = 29;  end

for i = 1:12
    day_of_year = day_of_year - month_lengths(i);
    if day_of_year <= 0
        month = i;
        day_of_month = day_of_year + month_lengths(i);
        break;
    end
end

end

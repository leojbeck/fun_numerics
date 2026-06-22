%January 11, 2020
%this is my first prime number using a^(m-1)= 1(mod m)
%I know that matlab has its own prime function
clear; clc
tic
c = 0;
for m = 3:2000 %modulo number   
    for a = 2: round(sqrt(m)) % base of exponent       
        if gcd(a, m) == 1 %checks to see if a & m are relatively prime
            r = uint64(mod(pow2(m-1), m)); % creates remainder
            
            if r ~= 1 %checks if remainder is not 1 (makes m composite
                break;
            end 
        end
    end
    if r == 1
        c = c + 1; % adds 1 to counter of primes (helps check if program works)
        m % displays prime
    end
end
c  % displays the total number of primes to that point
toc
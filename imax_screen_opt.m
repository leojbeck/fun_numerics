%% compare_crop_models.m
% Compare "linear-x" crop/blank model vs exact hyperbolic geometry model
% across a range of relative weights (w_m/w_s), for IMAX->35mm reformatting.

clear; clc;

%% --- User-set parameters ---------------------------------------------
a1 = 1.43;      % IMAX image aspect ratio
a2 = 2.39;      % 35mm scope screen aspect ratio

w_s = 0.75;        % weight on screen-fill term (1-s)^2
w_m = 1- w_s;        % weight on image-completeness term (1-m)^2
                % set w_s = w_m for the "equal weight" case;
                % w_m > w_s favors keeping more of the image (less crop);
                % w_s > w_m favors filling more of the screen width.

k  = a1/a2;     % ~0.598, the shared extreme value for s and m
r_sample = w_m / w_s;

%% --- Sweep range for the overview plot --------------------------------
r = logspace(-1.5, 1.5, 200);   % w_m/w_s from ~0.03 to ~30

%% --- Linear model: s(x) = k + (1-k)x, m(x) = 1 - (1-k)x -------------
% Minimize F = w_s*(1-s)^2 + w_m*(1-m)^2
%   (1-s) = (1-k)(1-x), (1-m) = (1-k)x
% F(x) = (1-k)^2 [ w_s*(1-x)^2 + w_m*x^2 ]
% dF/dx = 0  ->  x* = w_s / (w_s + w_m) = 1/(1+r)
x_lin = 1 ./ (1 + r);
s_lin = k + (1-k).*x_lin;
m_lin = 1 - (1-k).*x_lin;

%% --- Exact model: s*m = k, minimize F = w_s*(1-s)^2 + w_m*(1-m)^2 ---
% Substitute m = k/s, solve dF/ds = 0 numerically for each r.
s_exact = zeros(size(r));
for i = 1:length(r)
    ws = 1; wm = r(i);
    dF = @(s) -2*ws*(1-s) + 2*wm*(1 - k./s).*(k./s.^2);
    s_exact(i) = fzero(dF, k + (1-k)*x_lin(i));  % linear soln as initial guess
end
m_exact = k ./ s_exact;

%% --- Overview figure across all weights --------------------------------
figure;

subplot(2,1,1);
semilogx(r, s_lin, 'b-', r, s_exact, 'b--', ...
         r, m_lin, 'r-', r, m_exact, 'r--', 'LineWidth', 1.5);
xlabel('weight ratio w_m/w_s');
ylabel('fraction');
legend('s (linear)', 's (exact)', 'm (linear)', 'm (exact)', 'Location', 'best');
title('Screen fraction (s) and image fraction (m) vs weight ratio');
grid on;

subplot(2,1,2);
semilogx(r, s_lin - s_exact, 'k-', 'LineWidth', 1.5);
xlabel('weight ratio w_m/w_s');
ylabel('s_{linear} - s_{exact}');
title('Discrepancy between linear-x and exact hyperbolic models');
grid on;

%% --- Solve for the chosen (sample) weight ------------------------------
x_lin_s = 1 / (1 + r_sample);
s_lin_s = k + (1-k)*x_lin_s;
m_lin_s = 1 - (1-k)*x_lin_s;

dF_s = @(s) -2*w_s*(1-s) + 2*w_m*(1 - k./s).*(k./s.^2);
s_exact_s = fzero(dF_s, s_lin_s);
m_exact_s = k / s_exact_s;

fprintf('At chosen weights (w_s = %.3g, w_m = %.3g, r = w_m/w_s = %.4f):\n', ...
        w_s, w_m, r_sample);
fprintf('  linear model: x* = %.4f, s = %.4f, m = %.4f\n', ...
        x_lin_s, s_lin_s, m_lin_s);
fprintf('  exact  model: s* = %.4f, m = %.4f\n', s_exact_s, m_exact_s);

%% --- Component/sum figure for the chosen weight ------------------------
figure;

% Linear model: components and sum vs x
x_range = linspace(0, 1, 300);
s_of_x = k + (1-k).*x_range;
m_of_x = 1 - (1-k).*x_range;
term_s_lin = w_s*(1 - s_of_x).^2;
term_m_lin = w_m*(1 - m_of_x).^2;
F_lin = term_s_lin + term_m_lin;

subplot(2,1,1);
plot(x_range, term_s_lin, 'b-', x_range, term_m_lin, 'r-', ...
     x_range, F_lin, 'k-', 'LineWidth', 1.5);
hold on;
xline(x_lin_s, 'k--');
plot(x_lin_s, w_s*(1-s_lin_s)^2 + w_m*(1-m_lin_s)^2, 'ko', ...
     'MarkerFaceColor', 'k');
hold off;
xlabel('x (crop parameter)');
ylabel('penalty');
legend('w_s(1-s)^2', 'w_m(1-m)^2', 'sum F', 'optimum', 'Location', 'best');
title(sprintf('Linear model: components vs x  (w_s=%.3g, w_m=%.3g)', w_s, w_m));
grid on;

% Exact model: components and sum vs s (s in [k,1], m = k/s)
s_range = linspace(k, 1, 300);
m_of_s = k ./ s_range;
term_s_exact = w_s*(1 - s_range).^2;
term_m_exact = w_m*(1 - m_of_s).^2;
F_exact = term_s_exact + term_m_exact;

subplot(2,1,2);
plot(s_range, term_s_exact, 'b-', s_range, term_m_exact, 'r-', ...
     s_range, F_exact, 'k-', 'LineWidth', 1.5);
hold on;
xline(s_exact_s, 'k--');
plot(s_exact_s, w_s*(1-s_exact_s)^2 + w_m*(1-m_exact_s)^2, 'ko', ...
     'MarkerFaceColor', 'k');
hold off;
xlabel('s (screen fraction)');
ylabel('penalty');
legend('w_s(1-s)^2', 'w_m(1-m)^2', 'sum F', 'optimum', 'Location', 'best');
title(sprintf('Exact model: components vs s  (w_s=%.3g, w_m=%.3g)', w_s, w_m));
grid on;
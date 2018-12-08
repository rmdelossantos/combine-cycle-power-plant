%{
    PROJECT DETAILS
    - EE191 Machine Learning Project - Regression
    - A regression algorithm predicting the full capacity...
      output of a combined cycle power plant using...
      temperature and relative humidity data
    - Data set obtained from https://archive.ics.uci.edu/...
      ml/datasets/combined+cycle+power+plant
    - Russ M. Delos Santos (2012-19508)
    - Jim Reynoso (2013-73161)
%}

%{
    DATA INITIALIZATION
    - imports data from data.xlsx file
    - data format from raw .xslx file should be as follows
    "Temperature"   "Relative Humidity"   "Energy Output"
%}

data = xlsread('data.xlsx'); %import dataset
[data_points,columns] = size(data); %get # of data points

%randomly shuffles the data
training_data = data(randperm(size(data,1)),:);

%separate training(70%) and validation(30%) data sets
for i = 1:ceil(data_points*.30)
    [rows, columns] = size(training_data);
    index = randi(rows);
    validation_data(i,:) = training_data(index,:);
    training_data(index,:) = [];
end

%{
    TRAINING
    -polynomial regression
    -solve for coefficients
    -x^2 for temperature
    -x for relative humidity
    -y for real data
    -coefficients for computed weights
    -SSE for sum of squared errors
%}
training_x(:,1) = training_data(:,1).^2;
training_x(:,2) = training_data(:,2);
training_x(:,3) = 1;
training_y = training_data(:,3);
training_xT = transpose(training_x);
coefficients = inv(training_xT*training_x)...
                        *(training_xT*training_y);
training_SSE = (transpose(training_y-(training_x*coefficients)))...
                *(training_y-training_x*coefficients)

%{
    VALIDATION
    - use computed coefficients to estimate y
%}
validation_x(:,1) = validation_data(:,1).^2;
validation_x(:,2) = validation_data(:,2);
validation_x(:,3) = 1;
validation_y = validation_data(:,3);
validation_SSE = (transpose(validation_y-(validation_x*coefficients)))...
                  *(validation_y-validation_x*coefficients)

%{
    OUTPUT
    -plot predicted output (energy output) per input x
%}
if max(validation_data(:,1))> max(validation_data(:,2))
   maxvalue = max(validation_data(:,1));
else maxvalue = max(validation_data(:,2));
end
[rows,columns]= size(validation_y);
figure(); 
hold on;
grid on;
title('Predicted Value Plots VS Input X')
x = linspace(0,maxvalue,rows);
y = polyval(coefficients,x);
plot(x,y,'x');
hold off;


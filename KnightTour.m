function KnightTour
 
   dimX = 8;
   dimY = 8;
   board = zeros([dimX dimY]); % Default setting
   currentX = 0;
   currentY = 0;
   h = createBoard(board, dimX, dimY); % h -- 2D array handles
   h_fig = figure; % Create a figure for plotting
   axis([0 70 0 70]); % Create axes
   h_axis = gca;
   xlabel('Steps of Movement');
   ylabel('Number of Occupied Squares');
   title('Number of Occupied Squares vs. Steps of Movement');
   hold on;
   sec = 0.5; % Sleep 1 seconds
   pause(sec);

   % initialize the Knight position
   % rand(1) generates a number in the range [0,1], multiply 7 to have
   % a range [0, 7], then add 1 to get a range [1, 8]
   initX = 5;
   initY = 1;
   [currentX, currentY, board] = updateBoard(board, initX, initY);
   updateBoardDisplay(board, h, currentX, currentY);
   pause(sec);
   
%    [x, y] = nextPossibleMovement(board, currentX, currentY);
%    for i=1:length(x)
%       n = accessibility(board, x(i), y(i));
%    end

   prevPosX = 0;
   prevPosY = 0;
   nextPosX = -999;
   nextPosY = -999;
   numSteps = 0;
   while(nextPosX ~= prevPosX & nextPosY ~= prevPosY)
      % Find number of occupied squares
      sqOccup = size(find(board==1));
      % Start from the current position to decide next movement
      [nextPosX, nextPosY] = decisionMaker(board, currentX, currentY);
      % Update the board and current position
      prevPosX = currentX;
      prevPosY = currentY;
      [currentX, currentY, board] = updateBoard(board, nextPosX, nextPosY);
      updateBoardDisplay(board, h, currentX, currentY);
      numSteps = numSteps + 1; % The last summation is redundant, but the 
                               % initial one has not been taken into
                               % account. so we need this summation.                               
      a = set(h_axis);                         
      plot(numSteps, sqOccup(1), 'ko');
      set(h_axis,'XLim',[0 70],'YLim',[0 70]);                         
      pause(sec);
   end 
   
   str = sprintf('The number of steps to fill the chess board is %d.', numSteps);
   disp(str);
   
   aa = 1;

end

% update the current pos to (i,j)
function [currX, currY, obj] = updateBoard(aBoard, i, j)
   currX = i;
   currY = j;
   aBoard(i, j) = 1; % Mark visited
   obj = aBoard;
end

function h = createBoard(board, dimX, dimY)
   for i=1:dimX
      for j=1:dimY
         h(i,j) = rectangle('Position', [i, j, 1, 1]);
         set(h(i,j), 'FaceColor', 'g');
      end
   end
end

%% Input arguments are board and graphic object handlers
%function displayBoard(board, h, dimX, dimY)
%   for i=1:dimX
%      for j=1:dimY
%         if(board(i, j) == 1)
%             set(h(i,j), 'FaceColor', 'b');
%         end
%      end
%   end
   
%%   disp(board);
%end

% Update the color for the new momvement
function updateBoardDisplay(board, h, currentX, currentY);
   set(h(currentX, currentY), 'FaceColor', 'b');
end

% Input the current position, the fct gives a set of available
% candidates for the next movement
function [x,y] = nextPossibleMovement(board, i, j)
   indx = 1;
   x(1) = i;
   y(1) = j;
   begin_x = [i -2];
   end_x = [i 2];
   begin_y = [j -1];
   end_y = [j 1];
   for k=sum(begin_x):4:sum(end_x)
      for m=sum(begin_y):2:sum(end_y)
         if (k>=1 & k<=8 & m>=1 & m<=8) 
            if(board(k, m)<1) % Unvisited
               x(indx) = k;
               y(indx) = m;
               indx = indx + 1;
            end
         end
      end
   end
   begin_y = [j -2];
   end_y = [j 2];
   begin_x = [i -1];
   end_x = [i 1];
   for m=sum(begin_y):4:sum(end_y)
      for k=sum(begin_x):2:sum(end_x)
         if(k>=1 & k<=8 & m>=1 & m<=8)
            if(board(k, m)<1) % Unvisited
               x(indx) = k;
               y(indx) = m;
               indx = indx + 1;
            end
         end
      end
   end
end

% Input a position (i,j), the function calculates the accessibility
function num = accessibility(board, i, j)
	num = 0;
   begin_x = [i -2];
   end_x = [i 2];
   begin_y = [j -1];
   end_y = [j 1];
   for k=sum(begin_x):4:sum(end_x)
      for m=sum(begin_y):2:sum(end_y)
         if(k>=1 & k<=8 & m>=1 & m<=8)
            if(board(k,m)<1) % Unvisited
               num = num + 1;
            end
         end
      end
   end
   begin_y = [j -2];
   end_y = [j 2];
   begin_x = [i -1];
   end_x = [i 1];
   for m=sum(begin_y):4:sum(end_y)
      for k=sum(begin_x):2:sum(end_x)
         if(k>=1 & k<=8 & m>=1 & m<=8)
            if(board(k,m)<1) % Unvisited
               num = num + 1;
            end
         end
      end
   end
%    if(num == 0)
%       str = sprintf('The zero accessibility is found at x = %d, y = %d', i, j);
%       disp(str );
%       exit(1);
%    end
end % accessibility(...)

function [nextPosX, nextPosY] = decisionMaker(board, currentX, currentY)
   [xTmp,yTmp] = nextPossibleMovement(board, currentX, currentY);
   num = 999;
   nextPosX = currentX;
   nextPosY = currentY;
   for i=1:length(xTmp)
      numTmp = accessibility(board, xTmp(i), yTmp(i));
      if(numTmp<num)
         num = numTmp;
         nextPosX = xTmp(i);
         nextPosY = yTmp(i);
      end
   end % if cannot find available candidates, not move
end % decisionMaker

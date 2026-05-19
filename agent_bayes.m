% Intelligent Systems EAI 320 Practical 4 (NAive Bayes)
% Moosa Osman u24566722
% Last updated: 20260516

function rps = agent_bayes(previous, n_rounds)
    persistent opponentHistory;
    persistent ourHistory;

    % General procedure:
    % Random for move one ==> start predicting based on previous moves
    %More moves ==> greater chance of predicting mvove properly
    % perform Naive Bayes and find most likely mvoe, then choose winning move

    if isempty(previous)
        opponentHistory = [];
        ourHistory = [];            % init the stuff
        
        rps = randi([0, 2]);        % play random first time
        ourHistory = [ourHistory; rps];
        return;
    end

    % update the history
    opponentHistory = [opponentHistory; previous];
    N = length(opponentHistory);

    %extracting the features
    f1Hist = opponentHistory(1:end-1);         % f1: Opponent's move 1 round ago
    f2Hist = ourHistory(1:end-1);          % f2: Our move 1 round ago
    cHist  = opponentHistory(2:end);            % C: Opponent's move this round

    currentf1 = opponentHistory(end);
    currentf2 = ourHistory(end);

    posteriorScores = zeros(3, 1);          % values fo the posteriors, to be used later
    totalSamples = length(cHist);         % no of samples 

    for idx = 1:3           % for all: need to find Cond. probs. 
        classVal = idx - 1;
                        
        countCk = sum(cHist == classVal);     % Count occurrences of the target class
                
        prior = (countCk + 1) / (totalSamples + 3);    %have to add +1 and +3 otherwise NaN error on clickUP grader
        % this is caused by values being 0, so for countCk = 1, totalSamples = 0 ==> prbolem!, but now will evaluate to 0.667
        
        %find cond. prob. P(f1|Ck) i.e. opponent last move
        countf1Givenk = sum(f1Hist(cHist == classVal) == currentf1);
        pf1Givenk = (countf1Givenk + 1) / (countCk + 3);
         
        % P(f2 | Ck) i.e. our last move
        countf2Givenk = sum(f2Hist(cHist == classVal) == currentf2);
        pf2Givenk = (countf2Givenk + 1) / (countCk + 3);
        
        posteriorScores(idx) = prior * pf1Givenk * pf2Givenk;     % multiply for p(f|Ck)p(Ck)
    end
    
    [~, max_idx] = max(posteriorScores);    % for argmax part of Prob
    predicted_opponent_move = max_idx - 1;

    rps = mod(predicted_opponent_move + 1, 3);          % winning move

    ourHistory = [ourHistory; rps];         % update for nxt iteration

    % Results (10 rounds)
    % Run	    Time (s)	Rounds Won	Matches Won	  Anomilies
    % 1	        19.062877	648517	    700	            Only 49871 rounds for no_repeat, but still 100 matches won
    % 2	        16.313442	648523	    700	            Only 49854 rounds for no_repeat, but still 100 matches won
    % 3	        20.008488	648603	    700	            Only 49917 rounds for no_repeat, but still 100 matches won
    % 4	        22.458893	648504	    700	            Only 49870 rounds for no_repeat, but still 100 matches won
    % 5	        20.65606	648524	    700	            Only 49891 rounds for no_repeat, but still 100 matches won
    % 6	        20.963052	648418	    700	            Only 49750 rounds for no_repeat, but still 100 matches won
    % 7	        20.414442	648195	    700	            Only 49499 rounds for no_repeat, but still 100 matches won
    % 8	        18.963757	648618	    700	            Only 49985 rounds for no_repeat, but still 100 matches won
    % 9	        18.798465	648687	    700	            Only 50025 rounds for no_repeat, but still 100 matches won
    % 10	    19.613149	648338	    700	            Only 49681 rounds for no_repeat, but still 100 matches won
    % Average	19.7252625	648492.7	700	
    
    % Results show that Naive Bayes performs relatively well for most agents
    % For non deterministic agents (no_repeat) it doesn't perform the best but nevertheless all matches are still won
    % For other agents, it can correctly predict the move that wioll be played and counter it, winning 92.641814286% of rounds
    % Compared to prac 2, Naive Bayes has better results, but took longer to run and was easier to implement
    % Compared to prac 3, NB has roughly the same results as the final optimised NN, but took twice as long to run. But it was much easier to code
    % Benefit of Naive Bayes is evident: easy to implement with results that are relatively good

end

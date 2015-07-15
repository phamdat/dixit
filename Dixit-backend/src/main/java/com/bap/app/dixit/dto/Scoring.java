package com.bap.app.dixit.dto;

import java.util.Map;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.SCORING)
public class Scoring extends BaseRequest {

    private Map<String, Integer> selectedCards;
    private Map<Integer, String> playerGuessedCard;
    private Map<Integer, Integer> playerScore;

    public static Scoring create(Map<String, Integer> selectedCards, Map<Integer, String> playerGuessedCard, Map<Integer, Integer> playerScore) {
	Scoring c = new Scoring();
	c.setSelectedCards(selectedCards);
	c.setPlayerGuessedCard(playerGuessedCard);
	c.setPlayerScore(playerScore);
	return c;
    }

    public Map<String, Integer> getSelectedCards() {
	return selectedCards;
    }

    public void setSelectedCards(Map<String, Integer> selectedCards) {
	this.selectedCards = selectedCards;
    }

    public Map<Integer, String> getPlayerGuessedCard() {
	return playerGuessedCard;
    }

    public void setPlayerGuessedCard(Map<Integer, String> playerGuessedCard) {
	this.playerGuessedCard = playerGuessedCard;
    }

    public Map<Integer, Integer> getPlayerScore() {
	return playerScore;
    }

    public void setPlayerScore(Map<Integer, Integer> playerScore) {
	this.playerScore = playerScore;
    }

}

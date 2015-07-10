package com.bap.app.dixit.dto.object;

import java.util.LinkedHashMap;
import java.util.Map;

public class RoomData {

    private int state;
    private int hostId;
    private Map<String, Integer> selectedCards;
    private Map<String, Integer> guessedCards;
    private Map<Integer, PlayerData> players;

    public int getState() {
	return state;
    }

    public void setState(int state) {
	this.state = state;
    }

    public int getHostId() {
	return hostId;
    }

    public void setHostId(int hostId) {
	this.hostId = hostId;
    }

    public Map<Integer, PlayerData> getPlayers() {
	if (players == null) {
	    players = new LinkedHashMap<Integer, PlayerData>();
	}
	return players;
    }

    public void setPlayers(Map<Integer, PlayerData> players) {
	this.players = players;
    }

    public Map<String, Integer> getSelectedCards() {
	if (selectedCards == null) {
	    selectedCards = new LinkedHashMap<String, Integer>();
	}
	return selectedCards;
    }

    public void setSelectedCards(Map<String, Integer> selectedCards) {
	this.selectedCards = selectedCards;
    }

    public Map<String, Integer> getGuessedCards() {
	if (guessedCards == null) {
	    guessedCards = new LinkedHashMap<String, Integer>();
	}
	return guessedCards;
    }

    public void setGuessedCards(Map<String, Integer> guessedCards) {
	this.guessedCards = guessedCards;
    }

}

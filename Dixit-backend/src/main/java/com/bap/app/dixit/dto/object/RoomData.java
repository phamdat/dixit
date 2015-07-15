package com.bap.app.dixit.dto.object;

import java.util.LinkedHashMap;
import java.util.Map;

public class RoomData {

    private int state;
    private int hostId;
    private Map<String, Integer> selectedCards;
    private Map<Integer, String> playerGuessedCard;
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

    public Map<Integer, String> getPlayerGuessedCard() {
	if (playerGuessedCard == null) {
	    playerGuessedCard = new LinkedHashMap<Integer, String>();
	}
	return playerGuessedCard;
    }

    public void setPlayerGuessedCard(Map<Integer, String> playerGuessedCard) {
	this.playerGuessedCard = playerGuessedCard;
    }
}

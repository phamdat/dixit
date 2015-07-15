package com.bap.app.dixit.dto.object;

import java.util.List;

public class PlayerData {

    private int state;
    private int score;
    private List<Card> curCards;

    public int getState() {
	return state;
    }

    public void setState(int state) {
	this.state = state;
    }

    public int getScore() {
	return score;
    }

    public void setScore(int score) {
	this.score = score;
    }

    public List<Card> getCurCards() {
	return curCards;
    }

    public void setCurCards(List<Card> curCards) {
	this.curCards = curCards;
    }

    public void addScore(int score) {
	this.score += score;
    }
}

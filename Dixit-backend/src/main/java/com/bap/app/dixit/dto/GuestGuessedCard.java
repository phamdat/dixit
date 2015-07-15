package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.GUEST_GUESSED_CARD)
public class GuestGuessedCard extends BaseRequest {

    private int playerId;

    public static GuestGuessedCard create(int playerId) {
	GuestGuessedCard c = new GuestGuessedCard();
	c.setPlayerId(playerId);
	return c;
    }

    public int getPlayerId() {
	return playerId;
    }

    public void setPlayerId(int playerId) {
	this.playerId = playerId;
    }
}

package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.GUEST_SELECTED_CARD)
public class GuestSelectedCard extends BaseRequest {

    private int playerId;

    public static GuestSelectedCard create(int playerId) {
	GuestSelectedCard c = new GuestSelectedCard();
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

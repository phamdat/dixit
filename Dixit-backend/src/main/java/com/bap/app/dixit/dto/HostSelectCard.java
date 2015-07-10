package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.HOST_SELECT_CARD)
public class HostSelectCard extends BaseRequest {

    private int hostId;
    private String cardId;

    public static HostSelectCard create(int hostId) {
	HostSelectCard c = new HostSelectCard();
	c.setHostId(hostId);
	return c;
    }

    public int getHostId() {
	return hostId;
    }

    public void setHostId(int hostId) {
	this.hostId = hostId;
    }

    public String getCardId() {
	return cardId;
    }

    public void setCardId(String cardId) {
	this.cardId = cardId;
    }
}

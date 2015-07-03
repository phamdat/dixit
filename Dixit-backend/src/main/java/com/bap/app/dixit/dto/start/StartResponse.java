package com.bap.app.dixit.dto.start;

import java.util.List;

import com.bap.app.dixit.dto.object.Card;
import com.bap.app.dto.BaseResponse;

public class StartResponse extends BaseResponse {

    private int hostId;
    private List<Card> cards;

    public StartResponse(int hostId, List<Card> cards) {
	setSuccess(true);
	setHostId(hostId);
	setCards(cards);
    }

    public int getHostId() {
	return hostId;
    }

    public void setHostId(int hostId) {
	this.hostId = hostId;
    }

    public List<Card> getCards() {
	return cards;
    }

    public void setCards(List<Card> cards) {
	this.cards = cards;
    }

}

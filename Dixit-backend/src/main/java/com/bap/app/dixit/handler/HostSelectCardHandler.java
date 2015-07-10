package com.bap.app.dixit.handler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.bap.app.dixit.dao.CardDAO;
import com.bap.app.dixit.dto.GuestSelectCard;
import com.bap.app.dixit.dto.HostSelectCard;
import com.bap.app.dixit.dto.object.RoomData;
import com.bap.app.dixit.util.CommonUtils;
import com.bap.app.dixit.util.Constants;
import com.smartfoxserver.v2.entities.User;

public class HostSelectCardHandler extends BaseHandler<HostSelectCard> {

    @Autowired
    private CardDAO cardDAO;

    @Override
    public void execute(User sender, HostSelectCard t, RoomData rd) throws Exception {
	List<User> players = sender.getLastJoinedRoom().getPlayersList();

	rd.getSelectedCards().put(t.getCardId(), sender.getId());
	CommonUtils.updatePlayerState(rd, sender.getId(), Constants.GameState.HOST_SELECT_CARD);

	// notify that guest can select now
	for (User player : players) {
	    send(GuestSelectCard.create(), player);
	}
	CommonUtils.updateRoomState(rd, Constants.GameState.GUEST_GUESS_CARD);
    }
}

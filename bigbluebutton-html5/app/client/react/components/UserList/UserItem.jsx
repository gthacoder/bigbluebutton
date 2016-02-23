UserItem = React.createClass({

  handleKick(user) {
    return user.actions.kick(user);
  },

  handleMuteUnmute(user) {
    return user.actions.mute(user);
  },

  handleOpenPrivateChat(user) {
    return user.actions.openChat(user)
  },

  handleSetPresenter(user){
    return user.actions.setPresenter(user);
  },

  render() {
    const user = this.props.user;
    return (
      <tr className={classNames('user-list-item', user.isCurrent ? 'is-current' : null)}>
        {this.renderStatusIcons(user)}
        {this.renderUserName(user)}
        {this.renderSharingStatus(user)}
      </tr>
    );
  },

  renderStatusIcons(user) {
    let statusIcons = [];

    if (this.props.currentUser.isModerator && !user.isPresenter) {
      statusIcons.push((
        <Icon key="1" iconName="projection-screen" onClick={this.handleSetPresenter.bind(this, user)} title={`Set ${user.name} as presenter`}/>
      ));
    }

    if (user.isPresenter) {
      statusIcons.push((<Icon key="2" iconName="projection-screen" title={`${user.name} is the presenter`}/>));
    } else if (user.isModerator) {
      statusIcons.push((<Icon key="3" iconName="torso" title={`${user.name} is a moderator`}/>))
    }

    return (
      <td className="user-list-item-status">
        {statusIcons.map(i => i)}
      </td>
    );
  },


  renderUserName(user) {
    let classes = ['user-list-item-name'];
    let userName = user.name;

    if (user.isCurrent) {
      userName = userName.concat(' (you)');
    }

    if (user.unreadMessagesCount) {
      classes.push('has-messages');
    }

    return (
      <td className={classNames(classes)} onClick={() => this.handleOpenPrivateChat(user)}>
        <Tooltip title={userName}>
          {userName} {this.renderUnreadBadge(user.unreadMessagesCount)}
        </Tooltip>
      </td>
    );
  },

  renderUnreadBadge(unreadMessagesCount) {
    if (!unreadMessagesCount) {
      return;
    }

    return (
      <span className="user-list-item-messages">
        {(unreadMessagesCount > 9) ? '9+' : unreadMessagesCount}
      </span>
    );
  },

  renderSharingStatus(user) {
    const { sharingStatus, name: userName } = user;
    const currentUser = this.props.currentUser;

    let icons = [];

    if(sharingStatus.isInAudio) {
      if(sharingStatus.isListenOnly) {
        icons.push(<Icon iconName="volume-none"
        title={`${userName} is only listening`}/>);
      } else {
        if(sharingStatus.isMuted) {
          if(user.isCurrent) {
            icons.push(
              <Button className="muteIcon"
                onClick={() => this.handleMuteUnmute(user)}
                componentClass="span">
                <Icon prependIconName="ion-" iconName="ios-mic-off"
                  title={`${userName} is muted`}/>
              </Button>
            );
          } else {
            icons.push(<Icon prependIconName="ion-" iconName="ios-mic-off"
                  title={`${userName} is muted`}/>);
          }
        } else {
          let talkingStatusIcon = <Icon prependIconName="ion-"
            iconName="ios-mic-outline" title={`${userName} is not talking`}/>;

          if(sharingStatus.isTalking) {
            talkingStatusIcon = <Icon prependIconName="ion-" iconName="ios-mic"
            title={`${userName} is talking`}/>;
          }

          if(user.isCurrent) {
            icons.push(
              <Button
                onClick={() => this.handleMuteUnmute(user)}
                componentClass="span">
                {talkingStatusIcon}
              </Button>
            );
          } else {
            icons.push(
              <Button componentClass="span">
                {talkingStatusIcon}
              </Button>
            );
          }
        }
      }
    }

    if (!user.isCurrent && currentUser.isModerator) {
      icons.push(
        <Button className="kickUser" onClick={() => this.handleKick(user)} componentClass="span">
          <Icon iconName="x-circle" title={`Kick ${userName}`} className="icon usericon"/>
        </Button>
      );
    }

    if (sharingStatus.isWebcamOpen) {
      icons.push(<Icon iconName="video" title={`${userName} is sharing their webcam`}/>);
    }

    if (sharingStatus.isLocked) {
      icons.push(<Icon iconName="lock" title={`${userName} is locked`}/>);
    }

    // {icons.map((item, i) => {
    //   return (<td key={i}>oi</td>);
    // })}

    return (
      <td className="user-list-item-sharing">
        <table className="user-list-item-sharing-list">
          <tbody>
            <tr>
              {icons.map((item, i) => {
                return (<td key={i}>{item}</td>);
              })}
            </tr>
          </tbody>
        </table>
      </td>
    );
  }
})

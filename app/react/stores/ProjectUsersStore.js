import alt from '../alt';

import ProjectUsersActions from '../actions/ProjectUsersActions';
import MembershipStore from './MembershipStore';
import Moment from 'moment';

class ProjectUsersStore {
  constructor() {
    this.bindActions(ProjectUsersActions);
    this.users = [];
  }

  static getUser(userId) {
    const user = this.state.users.filter(user => user.id == userId);
    if(user.length > 0) {
      return user[0];
    }
    return null;
  }

  static getUsersNotInProjectNow(projectId) {
    const userIdsInProject = MembershipStore
      .memberships(projectId)
      .filter(membership => membership.ends_at === null ||
        Moment(membership.ends_at).endOf('day') >= Moment().endOf('day'))
      .map(membership => membership.user_id);

    return this.state.users.filter(user => userIdsInProject.indexOf(user.id) == -1);
  }

  static setInitialState(users) {
    this.state.users = users;
  }
}

export default alt.createStore(ProjectUsersStore);

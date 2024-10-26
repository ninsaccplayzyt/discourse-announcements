import Component from '@glimmer/component';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class AnnouncementAdmin extends Component {
  @service store;
  @tracked announcements = [];

  constructor() {
    super(...arguments);
    this.loadAnnouncements();
  }

  async loadAnnouncements() {
    this.announcements = await this.store.findAll('announcement');
  }

  @action
  async createAnnouncement(content) {
    const announcement = this.store.createRecord('announcement', { content });
    await announcement.save();
    this.announcements.pushObject(announcement);
  

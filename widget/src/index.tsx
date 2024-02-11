interface Config {
  entity?: string;
}

interface Hass {
  states: Record<string, {state: string}>;
}

class ContentCardExample extends HTMLElement {
  public content: HTMLElement | null = null;
  private config: Config | undefined;

  // Whenever the state changes, a new `hass` object is set. Use this to
  // update your content.
  public set hass(hass: Hass) {
    // Initialize the content if it's not there yet.
    if (!this.content) {
      this.innerHTML = `
        <ha-card header="Example-card">
          <div class="card-content"></div>
        </ha-card>
      `;
      this.content = this.querySelector('div');
    }

    if (this.config?.entity === undefined) {
      return;
    }

    const entityId = this.config.entity;
    const state = hass.states[entityId];
    const stateStr = state ? state.state : 'unavailable';

    if (this.content) {
      this.content.innerHTML = `
      The state of ${entityId} is ${stateStr}!
      <br><br>
      <img src="http://via.placeholder.com/350x150">
    `;
    }
  }

  // The user supplied configuration. Throw an exception and Home Assistant
  // will render an error card.
  public setConfig(config: Config): void {
    if (config.entity === undefined) {
      throw new Error('You need to define an entity');
    }
    this.config = config;
  }

  // The height of your card. Home Assistant uses this to automatically
  // distribute all cards over the available columns.
  public getCardSize(): number {
    // eslint-disable-next-line @typescript-eslint/no-magic-numbers
    return 3;
  }
}

customElements.define('content-card-example', ContentCardExample);

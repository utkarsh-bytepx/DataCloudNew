import { LightningElement, track } from 'lwc';

export default class Snowflake extends LightningElement {
    @track height = '900px';
    @track url = 'https://salesforceui-djgvmuegm3nhrv2wugfiuw.streamlit.app/?embedded=true';
    @track width = '100%';

    renderedCallback() {
        window.addEventListener('error', (e) => {
            console.error('Iframe Error Detected:', e);
        }, true);
    }
}
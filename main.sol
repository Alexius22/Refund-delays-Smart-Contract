pragma solidity >=0.4.22 <0.6.0;

//È necessario acquistare un biglietto inserendo il costo in value e poi cliccando su buyTicket

contract Viaggio {

	string public description = ""; //Stringa per avere un output visivo dei vari comandi 
	uint public check_delay = 0; //Controllo ammontare ritardo
	address owner;
	uint check_refund; //Controllo refund richiesto
	
	// Tabella in cui viene associato il biglietto con la propria transazione
	mapping(address=>uint) tickets;
	
	//Funzione per comprare il biglietto
	function buyTicket() public payable {
		require(msg.value >= 1, "Inserire un value maggiore o uguale ad 1");
		description = "Biglietto acquistato";
		tickets[msg.sender] = msg.value;
		owner = msg.sender;
	}

	//Funzione che in caso di ritardo rimborsa il cliente
	function getRefund() public {
		require(msg.sender == owner);
		string memory out_msg = "";
		uint refund = 0;
		
		if (check_delay == 0 && check_refund == 0) {
			out_msg = "Il treno non ha ritardi, non puoi richiedere alcun rimborso";
		} else if (check_delay == 1 && check_refund == 0) {
			refund = tickets[msg.sender] * 25 / 100;
			check_refund = 1;
			check_delay = 0;
			out_msg = "Il treno ha un ritardo di almeno 15 minuti, riceverai un rimborso del 25%";
		} else if (check_delay == 2 && check_refund == 0){
			refund = tickets[msg.sender] * 50 / 100;
			check_refund = 1;
			check_delay = 0;
			out_msg = "Il treno ha un ritardo di almeno 30 minuti, riceverai un rimborso del 50%";
		} else if (check_delay >= 3 && check_refund == 0){
			refund = tickets[msg.sender] * 100 / 100;
			check_refund = 1;
			check_delay = 0;
			out_msg = "Il treno ha un ritardo di almeno 60 minuti, riceverai un rimborso del 100%";
		}  else if (check_delay == 0 && check_refund == 1){
			out_msg = "Hai già ricevuto il rimborso";
		}
		address(msg.sender).transfer(refund);
		description = out_msg;
	}
	
	//Funzione per aumentare il ritardo del treno in locale
	function add_delay() public returns(uint) {
		if (check_refund == 0){
			check_delay++;
			description = "Ritardo treno aumentato";
			return check_delay;
	    } else {
			description = "Error: biglietto rimborsato (?)";    
		}     
	}

}

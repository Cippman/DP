--Auther : K.J. Aris
--Version : 13.10.25.10.42
--ScriptID : 70000899

--/? world 0 108 0 759 30 573
----------------------------------------------------------------------Christmas_Skills
--function Lua_70000899_ChristmasInit()
	--variable settings
	--lists
	local _lua_70000899_SnowManBuffIDs = { 30009048 , 30009049 , 30009050 , 30009051 , 30009052 };--�Ǫ��Q������  �H���ܳ��H������ 
	local _lua_70000899_SnowManInvalidTargetOrgIDs = { [10011853] = "Sentry" , [10011854] = "Dispenser" , [10011856] = "Frozer" };--�L�k�Q�ᵲ���ؼ�(�\�૬���H) --IDs on this list won't be frozen as a SnowMan.
	
	--10011840�����L
	--10011841����
	--10011843 ���H
	local _lua_70000899_MonsterDamage = { [10011840] = 1 , [10011841] = 5 , [10011843] = 10 };--�����j�ת�(�ܴH�@��)
	local _lua_70000899_MonsterArmor = { [10011840] = 2 , [10011841] = 5 , [10011843] = 10 };--�Ǫ��@��(�ܴH�@��)

	--30009380��§���᪺�q���L
	--30009381��§���᪺����
	local _lua_70000899_MonsterCustume ={ [10011840] = 30009380 , [10011841] = 30009381 };--�Ǫ����˪�

	--basic magics
	local _lua_70000899_FrozeBuffID = 30009035;--30009035�ᵲ
	local _lua_70000899_snowBallBuffID = 30009041;--���y�uBUFF ID
	
	--���a�Ѽ�
	local _lua_70000899_playerSnowManBuffID = 30009405;--���a�ܳ��H��BUFF
	local _lua_70000899_playerDamage = 1;--���a���y�����j��--against_lua_70000899_snowBallBuffID 30009041
	local _lua_70000899_playerFrozenDropSnowNum = 10;--���a�Q�ᦨ���H�ɱ������y�q--_lua_70000899_snowBallBuffID 30009041	-- <0�ɪ�������
	local _lua_70000899_warmArmorMaxLV = 100;--�ܴH�@�ҳ̰��h��


	--�t�ϩ�
	local _lua_70000899_liveTimeAfterGetGift = 120;--(��)�Ǫ�����§����������ɶ�

	
	--�\�૬���H
	local _lua_70000899_SnowManLiveTimerBuff = 30009275;--���H�s�b�˼ƭp��BUFF( ��ܥ� )

	--�]���H�Ѽ� 
	local _lua_70000899_sentryAvatarID = 10011853;--10011853 �]���HoriID

	local _lua_70000899_sentryLiveTime = 450;--�]���H�s�b�ɶ�
	local _lua_70000899_sentryArmor = 30;--�]���H�@��

	--�����H�Ѽ�
	local _lua_70000899_dispenserAvatarID = 10011854;--10011854 �����HoriID

	local _lua_70000899_dispenserLiveTime = 450;--�����H�s�b�ɶ�
	local _lua_70000899_snowBallPeriod = 50;--���y��ͦ����j 
	local _lua_70000899_dispenserArmor = 30;--�����H�@��

	--���y��Ѽ�
	local _lua_70000899_snowBallAvatarID = 10011855;--10011855 ���y��oriID

	local _lua_70000899_snowBallLiveTime = 150;--���y��s�b�ɶ�
	local _lua_70000899_snowBallsEachPack = 10;--�C�ﳷ�y���ƶq(�C�����o�ƶq)

	--�B�᳷�H�Ѽ�
	local _lua_70000899_frozerAvatarID = 10011856;--10011856 �B�᳷�HoriID
	local _lua_70000899_frozerSpellID = 31010206;--31010206�w�B���p
	local _lua_70000899_frozerBuffID = 30008516;--30008516�w�B���pBUFF

	local _lua_70000899_frozerLiveTime = 450;--�B�᳷�H�s�b�ɶ�
	local _lua_70000899_frozerActivePeriod = 10;--�B��k�N�I�i���j
	local _lua_70000899_frozerArmor = 30;--�B�᳷�H�@��

	--����Ѽ�
	local _lua_70000899_warmArmorBuffID = 30009240;--30009240�ܴH�@��
	local _lua_70000899_warmArmorSkillID = 31010207;--31010207�W�[�ܴH�@��

	local _lua_70000899_warmArmorActivePeriod = 20;--�@�Ҧ^�_�I�i���j
--end
	

	------------------------------------------------------------------------------------------���y
	function Lua_70000899_FrozeAsSnowMan()
		local _ownerID = OwnerID();
		local _targetID = TargetID();

		local _ownerIsPlayer = ReadRoleValue( _ownerID , EM_RoleValue_IsPlayer );
		local _targetIsPlayer = ReadRoleValue( _targetID , EM_RoleValue_IsPlayer );
		--30007735���y����	--30009035�ᵲ

		--�ˬd�ᵲ�L��
		local _freezeInvalidTarget = Lua_70000899_CheckSnowManInvalidTarget( _targetID );
		if ( _freezeInvalidTarget ) then--if = �ᵲ���ĥؼ�
			--for PC
			if ( _ownerIsPlayer == 0 and _targetIsPlayer == 1 ) then--��NPC����PC��
				local _hasArmor = CheckBuff( _targetID , _lua_70000899_warmArmorBuffID );
				if ( _hasArmor ) then--�ˬd���a�ܴH�@��

					local _damage = Lua_70000899_CheckDamageValue( _ownerID );

					Lua_ChangeBuffPower( _targetID , _targetID , _lua_70000899_warmArmorBuffID , -_damage );--��z�@��
					AddBuff( _targetID , _ownerID , _lua_70000899_frozerBuffID , 1 , 20 );--30008516�w�B���p
					return;--���@�Ҥ��ܳ��H
				end

				--�ܳ��H
				if ( not CheckBuff( _targetID , _lua_70000899_FrozeBuffID ) ) then--�Y�w�Q�ᵲ�h���A��
					local _snowManBuff = _lua_70000899_playerSnowManBuffID;--_lua_70000899_SnowManBuffIDs[ RandRange( 1 , #_lua_70000899_SnowManBuffIDs ) ];
					AddBuff( _targetID , _ownerID , _lua_70000899_FrozeBuffID , 1 , 30 );
					AddBuff( _targetID , _ownerID , _snowManBuff , 1 , 30 );--AddBuff( INT64 TargetID, INT64 CasterID, Int MagicBaseID, Int MagicLV, Int effectTime )
					--DebugMsg( 0 , "----".._ownerID.." => ".._snowManBuff );

					--�����y
					Lua_ChangeBuffPower( _targetID , _targetID , _lua_70000899_snowBallBuffID , -_lua_70000899_playerFrozenDropSnowNum );
				end
				
				  		
			end
			
			--for NPC
			if ( _ownerIsPlayer == 1 and _targetIsPlayer == 0 ) then--��PC����NPC��
				local _hasArmor = CheckBuff( _targetID , _lua_70000899_warmArmorBuffID );
				if ( _hasArmor ) then--�ˬdNPC�ܴH�@��

					Lua_ChangeBuffPower( _targetID , _targetID , _lua_70000899_warmArmorBuffID , -_lua_70000899_playerDamage );--��z�@��
					AddBuff( _targetID , _ownerID , _lua_70000899_frozerBuffID , 1 , 20 );--30008516�w�B���p
					ScriptMessage( _targetID , _ownerID , EM_ScriptMessageSendType_Target , EM_ClientMessage_Yabber ,  Lua_Event_Xmas_BubbleString() , 0 );
					return;--���@�Ҥ���
				end
				--�S�@�ҥh��
				KillID( _targetID , _ownerID );
			end

		else --if = �ᵲ�L�ĥؼ�
			--�L�ĥؼХu���@��  ���ᵲ
			local _hasArmor = CheckBuff( _targetID , _lua_70000899_warmArmorBuffID );
			if ( _hasArmor ) then--�ˬdNPC�ܴH�@��
				local _damage = Lua_70000899_CheckDamageValue( _ownerID );
				Lua_ChangeBuffPower( _targetID , _targetID , _lua_70000899_warmArmorBuffID , -_damage );--��z�@��
				return;--���@�Ҥ���
			end
			--�S�@�ҥh��
			KillID( _targetID , _ownerID );
		end

		return false;
	end
	
	function Lua_70000899_CheckDamageValue( _InputAttackerID )--�d�ߩǪ��ˮ`��
		local _ownerID = _InputAttackerID;
		local _attackerOrgID = ReadRoleValue( _ownerID , EM_RoleValue_OrgID );
		local _damage = _lua_70000899_MonsterDamage[ _attackerOrgID ];
		
		if ( not _damage ) then
			return 0;
		end
		
		return _damage;
	end
	
	function Lua_70000899_CheckSnowManInvalidTarget( _InputID )--�ˬd�L�ĥؼ�
		local _result = false;
		local _targetOrgID = ReadRoleValue( _InputID , EM_RoleValue_OrgID );
		local _targetType = _lua_70000899_SnowManInvalidTargetOrgIDs[ _targetOrgID ];
		
		if ( not _targetType ) and ( _isPlayer ~= 1 ) then
			_result = true;
		--else
			--DebugMsg( 0 , "Invalid Target : ".._targetOrgID.." -------- it's a ".._targetType );
		end

		return _result;
	end


	function Lua_70000899_CheckDamageInvalid()--30009042���y�ˮ`
		local _ownerID = OwnerID();
		local _targetID = TargetID();
		--�ˬd�����L��
		local _isPlayer = ReadRoleValue( _targetID , EM_RoleValue_IsPlayer );

		return ( _isPlayer == 0 );
	end
	----------------------------------------------------------------------------END-----------���y

	--------------------------------------------------------------------------------------------����
	function Lua_70000899_OnlyWorksOnPlayer()--30009240�ܴH�@��
		local _ownerID = OwnerID();
		local _targetID = TargetID();
		--�ˬd���a
		local _isPlayer = ReadRoleValue( _targetID , EM_RoleValue_IsPlayer );

		return ( _isPlayer == 1 );
	end


	function Lua_70000899_AddWarmArmor()--NPC 10011961
		local _ownerID = OwnerID();
		local _targetID = TargetID();
		

		local _hasArmor = CheckBuff( _targetID , _lua_70000899_warmArmorBuffID );
		--DebugMsg( 0 , tostring( _hasArmor ) );
		if ( not _hasArmor ) then
			AddBuff( _targetID , _targetID , _lua_70000899_warmArmorBuffID , 0 , -1 );
			return false;
		end
		
		local _armorCounter = BuffInfo( _targetID , Lua_GetBuffPos( _targetID , _lua_70000899_warmArmorBuffID ) , EM_BuffInfoType_MagicLv ) + 1; 
		--DebugMsg( 0 , " BuffLV "..tostring( _armorCounter ).."   ".._lua_70000899_warmArmorMaxLV );
		if ( _armorCounter < _lua_70000899_warmArmorMaxLV ) then
			Lua_ChangeBuffPower( _targetID , _targetID , _lua_70000899_warmArmorBuffID , 1 );
		end 
		
		return false;
	end

	----------------------------------------------------------------------------END-------------����


	function Lua_70000899_CreateFunctionalSnowMan( _InputAvatarID )
		local _ownerID = OwnerID();
		local _roomID = ReadRoleValue( _ownerID , EM_RoleValue_RoomID );
		Lua_CreateObjByObjEX( _InputAvatarID , _ownerID , 0 , 15 , _roomID );--Int DataID, INT64 TargetObj, Int ang, Int dis, Int RoomID

		return false;
	end

	function Lua_70000899_CheckSnowBallStock( _InputRequire )--PC Skills
		local _ownerID = OwnerID();
		--local _lua_70000899_snowBallBuffID = 30009041;

		local _hasBalls = CheckBuff( _ownerID , _lua_70000899_snowBallBuffID );
		local _require = _InputRequire or 1;

		if ( not _hasBalls ) then
			ScriptMessage( _ownerID, _ownerID, EM_ScriptMessageSendType_Target, EM_ClientMessage_Warning , "Insufficient snowball !! go get some by the Dispenser !!" , 0 );
			return false;
		end
		
		local _snowBallCounter = BuffInfo( _ownerID , Lua_GetBuffPos( _ownerID , _lua_70000899_snowBallBuffID ) , EM_BuffInfoType_MagicLv ) + 1;
		local _sufficient = ( _snowBallCounter >= _require );

		if ( not _sufficient ) then
			ScriptMessage( _ownerID, _ownerID, EM_ScriptMessageSendType_Target, EM_ClientMessage_Warning , "Insufficient snowball !! go get some by the Dispenser !!" , 0 );
		end

		return _sufficient;
		--return true;
	end

	function Lua_70000899_ConsumeSnowBall( _InputConsume )--PC Skills
		local _ownerID = OwnerID();
		--local _lua_70000899_snowBallBuffID = 30009041;

		local _hasBalls = CheckBuff( _ownerID , _lua_70000899_snowBallBuffID );

		if ( _hasBalls ) then
			local _snowBallExpend = _InputConsume or 1;

			Lua_ChangeBuffPower( _ownerID , _ownerID , _lua_70000899_snowBallBuffID , -_snowBallExpend );

	--		local _snowBallCounter = 0;
	--		_snowBallCounter = BuffInfo( _ownerID , Lua_GetBuffPos( _ownerID , _lua_70000899_snowBallBuffID ) , EM_BuffInfoType_MagicLv );
	--		if ( _snowBallCounter <= 0 ) then
	--			CancelBuff( _ownerID , _lua_70000899_snowBallBuffID );
	--		end
		end--

	end

	function Lua_70000899_OnStartChristmasActivity( _InputOnwerID )--Lua_70000900_ActivityDrill
		local _ownerID = _InputOnwerID or OwnerID();
		--local _targetID = TargetID();
		DebugMsg( 0 , "Christmas Activity has started !!");
		Lua_70000899_SnowBallAcquisition( _ownerID );--�������y
		AddBuff( _ownerID , _ownerID , _lua_70000899_warmArmorBuffID , _lua_70000899_warmArmorMaxLV - 1 , -1 );--�����ܴH�@��
		
		return true;
	end


	--function Lua_70000899_OnEndChristmasActivity( _Type , _unknow )--Basic Magic 30009037
	function Lua_70000899_OnEndChristmasActivity()--Basic Magic 30009037
		local _ownerID = OwnerID();
		--local _lua_70000899_snowBallBuffID = 30009041;
		CancelBuff( _ownerID , _lua_70000899_snowBallBuffID );
		CancelBuff( _ownerID , _lua_70000899_warmArmorBuffID );

		--DebugMsg( 0 , "__".._Type.."____".._unknow );
	end
	--------------------------------------------------------------END-----Christmas_Skills


	----------------------------------------------------------------------Christmas_AIs
	function Lua_70000899_Christmas_AI_Init()
		local _ownerID = OwnerID();
		SetModeEx(  _ownerID  , EM_SetModeType_Fight, true); 
		SetModeEx(  _ownerID  , EM_SetModeType_Strikback, true); 
		SetModeEx(  _ownerID  , EM_SetModeType_Searchenemy, true );

		SetModeEx(  _ownerID  , EM_SetModeType_Mark, true); 
		WriteRoleValue( _ownerID , EM_RoleValue_Register + 1 , 0 );


		
		local _ownerOrgID = ReadRoleValue( _ownerID , EM_RoleValue_OrgID );
		local _armor = _lua_70000899_MonsterArmor[ _ownerOrgID ];
		
		if ( _armor ) then
			AddBuff( _ownerID , _ownerID , _lua_70000899_warmArmorBuffID , 0 , -1 );
		end

		Lua_ChangeBuffPower( _ownerID , _ownerID , _lua_70000899_warmArmorBuffID , _armor - 1 );

		local _isTheif =  ReadRoleValue( _ownerID , EM_RoleValue_Register ); 
		if ( _isTheif <= 0 ) then
			BeginPlot( _ownerID , "Lua_70000899_Christmas_AI_StealGift" , RandRange( 10 , 50 ) );
		end
	end--function Lua_70000899_Christmas_AI_StealGift

	function Lua_70000899_Christmas_AI_StealGift()--��§��
		local _ownerID = OwnerID();
		local _gotGift = ReadRoleValue( _ownerID , EM_RoleValue_Register + 1 ); 
		if ( _gotGift == 0 ) then
			BeginPlot( _ownerID , "Lua_70000899_Christmas_AI_ToPrimaryTarget" , 10 );
			--DebugMsg( 0 , "Stealing Gift : ".._ownerID );
		else	
			BeginPlot( _ownerID , "Lua_70000899_Christmas_AI_ReturnToHome" , 10 );
			--DebugMsg( 0 , "Returnung home : ".._ownerID );
		end
	end--function Lua_70000899_Christmas_AI_StealGift

	function Lua_70000899_Christmas_AI_TakeAndReturnToHome()--��§����^�a
		local _ownerID = OwnerID();
		local _targetID = TargetID();

		local _gotGift = ReadRoleValue( _targetID , EM_RoleValue_Register + 1 ); 
		if ( _gotGift == 0 ) then
			
			StopMove( _targetID , false );		
			
			local _randomPos = (RandRange( 0 , 100 ) % 4) + 1;
			WriteRoleValue( _ownerID , EM_RoleValue_Register + 1 , _randomPos );

			--WriteRoleValue( _targetID , EM_RoleValue_Register + 1 , 1 );
			--SetModeEx(  _targetID, EM_SetModeType_Strikback, false) ;---����
			SetModeEx(  _targetID, EM_SetModeType_Searchenemy, false) ;---����
				
			PlayMotionEX( _targetID , 34000702 , 34000702 , 0 );
				
			BeginPlot( _targetID , "Lua_70000899_Christmas_AI_ReturnToHome" , 20 );
		end
	
		return false;
	end--function Lua_70000899_Christmas_AI_TakeAndReturnToHome

	function Lua_70000899_Christmas_AI_ReturnToHome()--��^�X���I
		local _ownerID = OwnerID();
		local _gotGift = ReadRoleValue( _ownerID , EM_RoleValue_Register + 1 );

		if ( _gotGift == 0 ) then
			local _randomPos = (RandRange( 0 , 100 ) % 4) + 1;
			WriteRoleValue( _ownerID , EM_RoleValue_Register + 1 , _randomPos );
			_gotGift = ReadRoleValue( _ownerID , EM_RoleValue_Register + 1 );
			WriteRoleValue( _ownerID , EM_RoleValue_LiveTime , _lua_70000899_liveTimeAfterGetGift );
			Lua_70000899_Christmas_AI_WearCustume( _ownerID );--����
			PE_AddVar("PE_EVT_Xmas_Gifts" , 1 );--�g�n�� 
		end

		SetModeEx(  _ownerID , EM_SetModeType_Searchenemy, false) ;---����
		--DebugMsg( 0 , " _ ".._ownerID.."Returning to ".._gotGift );	
		--Lua_MoveToFlag( _ownerID , _lua_70000900_Christmas_FlagID , _gotGift , 0 );
		Lua_WaitToMoveFlag( _ownerID , _lua_70000900_Christmas_FlagID , _gotGift , 0 );
		--PE_AddVar("PE_EVT_Xmas_Gifts" , 1 );--�^��_�ޤ~�g�n�� 
		Sleep( 20 );
		DelObj( _ownerID );
		
		
	end--function Lua_70000899_Christmas_AI_ReturnToHome

	function Lua_70000899_Christmas_AI_ToPrimaryTarget()--�e���ؼ�
		local _ownerID = OwnerID();
		MoveToFlagEnabled( _ownerID, false );

		SetModeEx(  _ownerID  , EM_SetModeType_Fight, true); 
		SetModeEx(  _ownerID  , EM_SetModeType_Strikback, true); 
		SetModeEx(  _ownerID  , EM_SetModeType_Searchenemy, true );

		SetModeEx(  _ownerID  , EM_SetModeType_Mark, true); 
		WriteRoleValue( _ownerID , EM_RoleValue_Register + 1 , 0 );

		Lua_MoveToFlag( _ownerID , _lua_70000900_Christmas_FlagID , 0 , 0 );
		--Lua_WaitToMoveFlag( _ownerID , _lua_70000900_Christmas_FlagID , 0 , 0 );
		--BeginPlot( _ownerID , "Lua_70000899_Christmas_AI_ReturnToHome" , 20 );
	end

	function Lua_70000899_Christmas_AI_WearCustume( _InputOwnerID )--����§�����ܸ�
		local _ownerID = _InputOwnerID;
		local _ownerOrgID = ReadRoleValue( _ownerID , EM_RoleValue_OrgID );
		local _custumeBuffID = _lua_70000899_MonsterCustume[ _ownerOrgID ];

		if ( not _custumeBuffID ) then
			return;
		end

		--DebugMsg( 0 , "Changing Custume : ".._ownerID.." -> ".._custumeBuffID );
		AddBuff( _ownerID , _ownerID , _custumeBuffID , 1 , -1 );--30008516�w�B���p
	end


	function Lua_70000899_Christmas_AI_Dead()
		local _ownerID = OwnerID();
		--30006871�ᵲ
		local _snowManBuff = _lua_70000899_SnowManBuffIDs[ RandRange( 1 , #_lua_70000899_SnowManBuffIDs ) ];
		AddBuff( _ownerID , _ownerID , _snowManBuff , 1 , 20 );--AddBuff( INT64 TargetID, INT64 CasterID, Int MagicBaseID, Int MagicLV, Int effectTime )
		AddBuff( _ownerID , _ownerID , _lua_70000899_FrozeBuffID , 1 , 20 );--AddBuff( INT64 TargetID, INT64 CasterID, Int MagicBaseID, Int MagicLV, Int effectTime )
		
		SetModeEx(  _ownerID  , EM_SetModeType_Fight, false); 
		SetModeEx(  _ownerID  , EM_SetModeType_Strikback, false); 
		SetModeEx(  _ownerID  , EM_SetModeType_Searchenemy, false );

		SetModeEx(  _ownerID  , EM_SetModeType_Mark, false); 
		--SetModeEx(  _ownerID  , EM_SetModeType_HideName, true); 
		--SetModeEx(  _ownerID  , EM_SetModeType_ShowRoleHead, false); 
		--SetModeEx(  _ownerID  , EM_SetModeType_NotShowHPMP, false );

		--Sleep( 50 );
		
		--DelObj( _ownerID );
		DebugMsg( 0 , "----".._ownerID.."is Dead" );

		CallPlot( _ownerID , "Lua_Event_Xmas_GiftsTheftDead" );
		BeginPlot( _ownerID , "Lua_70000899_Christmas_AI_Delete" , 20 );
		return false;
	end--function Lua_70000899_Christmas_AI_Dead

	function Lua_70000899_Christmas_AI_Delete()
		--Sleep( 20 );
		NPCDead( OwnerID() , OwnerID() ); 
		DelObj( OwnerID() );
		--DebugMsg( 0 , tostring( DelObj( OwnerID() ) ) );
		--return true;
	end--function Lua_70000899_Christmas_AI_Delete

	---------------------------------------------------------------------END---------Christmas_AIs



	----------------------------------------------------------------------Christmas_Items

	---------------------------------------------------------------------------------------------------------------Sentry
	function Lua_70000899_Christmas_Item_Sentry_Init()--NPC 10011853
		local _ownerID = OwnerID();
		--local _liveTime = 450;
		local _liveTime = _lua_70000899_sentryLiveTime;

		WriteRoleValue( _ownerID , EM_RoleValue_LiveTime , _liveTime );
		
		SetModeEx( _ownerID , EM_SetModeType_Revive , false );--������
		SetModeEx(  _ownerID, EM_SetModeType_Move, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Strikback, true) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Searchenemy, true) ;---����
		SetModeEx( _ownerID , EM_SetModeType_Fight, false) ;---�i���
		SetModeEx( _ownerID , EM_SetModeType_Obstruct, true) ;---�i����

		AddBuff( _ownerID , _ownerID , _lua_70000899_SnowManLiveTimerBuff , 0 , _liveTime*10 );
		AddBuff( _ownerID , _ownerID , _lua_70000899_warmArmorBuffID , _lua_70000899_sentryArmor - 1 , -1 );--�����ܴH�@��
	end
	-------------------------------------------------------------------------------------------END-----------------Sentry

	---------------------------------------------------------------------------------------------------------------Dispenser
	function Lua_70000899_Christmas_Item_Dispenser_Init()--NPC 10011854
		local _ownerID = OwnerID();
		--local _liveTime = 150;
		local _liveTime = _lua_70000899_dispenserLiveTime;

		WriteRoleValue( _ownerID , EM_RoleValue_LiveTime , _liveTime );
		
		SetModeEx( _ownerID , EM_SetModeType_Revive , false );--������
		SetModeEx(  _ownerID, EM_SetModeType_Move, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Strikback, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Searchenemy, false) ;---����
		SetModeEx( _ownerID , EM_SetModeType_Fight, false) ;---�i���
		SetModeEx( _ownerID , EM_SetModeType_Obstruct, true) ;---�i����
		
		AddBuff( _ownerID , _ownerID , _lua_70000899_SnowManLiveTimerBuff , 0 , _liveTime*10 );
		AddBuff( _ownerID , _ownerID , _lua_70000899_warmArmorBuffID , _lua_70000899_dispenserArmor - 1 , -1 );--�����ܴH�@��
		--CastSpell( _ownerID , _ownerID , 31010103 , 1 );
		BeginPlot( _ownerID , "Lua_70000899_Christmas_Item_Dispenser_OnDuty" , 20 );
	end

	function Lua_70000899_Christmas_Item_Dispenser_OnDuty()
		
		local _ownerID = OwnerID();
		local _roomID = ReadRoleValue( _ownerID , EM_RoleValue_RoomID );

		--local _liveTime = 150;
		local _liveTime = _lua_70000899_snowBallLiveTime
		--local _lua_70000899_snowBallAvatarID = 10011855;--10011855 ���y��	
		--local _lua_70000899_snowBallPeriod = 50;
		local _currentSnowBallID = 0;
		while true do
			_currentSnowBallID = Lua_CreateObjByObjEX( _lua_70000899_snowBallAvatarID , _ownerID , RandRange( 0 , 360 ) , RandRange( 10 , 20 ) , _roomID );--Int DataID, INT64 TargetObj, Int ang, Int dis, Int RoomID
			WriteRoleValue( _currentSnowBallID , EM_RoleValue_LiveTime , _liveTime );

			SetModeEx(  _currentSnowBallID, EM_SetModeType_Move, false) ;---����
			SetModeEx(  _currentSnowBallID, EM_SetModeType_Strikback, false) ;---����
			SetModeEx(  _currentSnowBallID, EM_SetModeType_Searchenemy, false) ;---����
			SetModeEx( _currentSnowBallID , EM_SetModeType_Fight, false) ;---�i���
			SetModeEx( _currentSnowBallID , EM_SetModeType_Obstruct, false) ;---�i����	
		
			Sleep( _lua_70000899_snowBallPeriod );
		end

	end

--	function Lua_70000899_Christmas_Item_Dispenser_GenerateSnowBall()
--		local _ownerID = OwnerID();
--		local _roomID = ReadRoleValue( _ownerID , EM_RoleValue_RoomID );
--
--		--local _liveTime = 150;
--		local _liveTime = _lua_70000899_snowBallLiveTime;
--		--local _lua_70000899_snowBallAvatarID = 10011855;--10011855 ���y��	
--		local _currentSnowBallID = 0;
--
--		_currentSnowBallID = Lua_CreateObjByObjEX( _lua_70000899_snowBallAvatarID , _ownerID , RandRange( 0 , 360 ) , RandRange( 10 , 20 ) , _roomID );--Int DataID, INT64 TargetObj, Int ang, Int dis, Int RoomID
--		WriteRoleValue( _currentSnowBallID , EM_RoleValue_LiveTime , _liveTime );
--
--		SetModeEx(  _currentSnowBallID, EM_SetModeType_Move, false) ;---����
--		SetModeEx(  _currentSnowBallID, EM_SetModeType_Strikback, false) ;---����
--		SetModeEx(  _currentSnowBallID, EM_SetModeType_Searchenemy, false) ;---����
--		SetModeEx( _currentSnowBallID , EM_SetModeType_Fight, false) ;---�i���
--		SetModeEx( _currentSnowBallID , EM_SetModeType_Obstruct, false) ;---�i����	
--
--		--DebugMsg( 0 , "--------Dispenser ".._ownerID.." created 1 ball." );
--	end
	-------------------------------------------------------------------------------------------END-----------------Dispenser

	---------------------------------------------------------------------------------------------------------------SnowBall
	function Lua_70000899_Christmas_Item_SnowBallPickup()
		local _ownerID = OwnerID();--player
		local _targetID = TargetID();--snow balls

		DelObj( _targetID );
		Lua_70000899_SnowBallAcquisition( _ownerID );
	end

	function Lua_70000899_SnowBallAcquisition( _InputTargetID )
		local _ownerID = _InputTargetID or OwnerID();--player
		
		--local _lua_70000899_snowBallBuffID = 30009041;
		--local _lua_70000899_snowBallsEachPack = 10;--10 balls each pack
		local _snowBallsAcquiredAmmount = _lua_70000899_snowBallsEachPack;
		local _hasBalls = CheckBuff( _ownerID , _lua_70000899_snowBallBuffID );

		if ( not _hasBalls ) then
			AddBuff( _ownerID , _ownerID , _lua_70000899_snowBallBuffID , 0 , -1 );
			_snowBallsAcquiredAmmount =  _snowBallsAcquiredAmmount - 1;
		end

		Lua_ChangeBuffPower( _ownerID , _ownerID , _lua_70000899_snowBallBuffID , _snowBallsAcquiredAmmount );

	end
	-------------------------------------------------------------------------------------------------END-----------SnowBall

	---------------------------------------------------------------------------------------------------------------Frozer
	function Lua_70000899_Christmas_Item_Frozer_Init()--NPC 10011856
		local _ownerID = OwnerID();
		--local _liveTime = 150;
		local _liveTime = _lua_70000899_frozerLiveTime;

		WriteRoleValue( _ownerID , EM_RoleValue_LiveTime , _liveTime );
		
		SetModeEx( _ownerID , EM_SetModeType_Revive , false );--������
		SetModeEx(  _ownerID, EM_SetModeType_Move, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Strikback, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Searchenemy, false) ;---����
		SetModeEx( _ownerID , EM_SetModeType_Fight, false) ;---�i���
		SetModeEx( _ownerID , EM_SetModeType_Obstruct, true) ;---�i����
		
		AddBuff( _ownerID , _ownerID , _lua_70000899_SnowManLiveTimerBuff , 0 , _liveTime*10 );
		AddBuff( _ownerID , _ownerID , _lua_70000899_warmArmorBuffID , _lua_70000899_frozerArmor - 1 , -1 );--�����ܴH�@��
		--CastSpell( _ownerID , _ownerID , 31010206 , 1 );--30008516
		BeginPlot( _ownerID , "Lua_70000899_Christmas_Item_Frozer_OnDuty" , 20 );
	end

	function Lua_70000899_Christmas_Item_Frozer_OnDuty()
		
		local _ownerID = OwnerID();

		while true do
			--DebugMsg( 0 , "-----Freeze" );
			CastSpell( _ownerID , _ownerID , _lua_70000899_frozerSpellID , 1 );--30008516
			sleep( _lua_70000899_frozerActivePeriod );
		end
	end
	------------------------------------------------------------------------------------------------END------------Frozer

	---------------------------------------------------------------------------------------------------------------Campfire
	function Lua_70000899_Christmas_Item_Campfire_Init()--NPC 10011961
		local _ownerID = OwnerID();
		local _liveTime = 950;
		--local _liveTime = _lua_70000899_frozerLiveTime;

		WriteRoleValue( _ownerID , EM_RoleValue_LiveTime , _liveTime );

		SetModeEx(  _ownerID, EM_SetModeType_Move, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Strikback, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Searchenemy, false) ;---����
		SetModeEx( _ownerID , EM_SetModeType_Fight, false) ;---�i���ss
		SetModeEx( _ownerID , EM_SetModeType_Obstruct, true) ;---�i����
		

		BeginPlot( _ownerID , "Lua_70000899_Christmas_Item_Campfire_OnDuty" , 20 );
	end

	function Lua_70000899_Christmas_Item_Campfire_OnDuty()
		
		local _ownerID = OwnerID();

		while true do
			CastSpell( _ownerID , _ownerID , _lua_70000899_warmArmorSkillID , 1 );--31010207�ܴH�@��
			sleep( _lua_70000899_warmArmorActivePeriod );
		end
	end
	-------------------------------------------------------------------------------------------END-----------------Campfire
	


	function Lua_70000899_Christmas_Item_GiftKeeper_Init()--NPC 10011838
		local _ownerID = OwnerID();
		--local _liveTime = 150;
		--local _liveTime = _lua_70000899_frozerLiveTime;
		DebugMsg( 0 , " GiftKeeper is on duty" );

		--WriteRoleValue( _ownerID , EM_RoleValue_LiveTime , _liveTime );

		SetModeEx(  _ownerID, EM_SetModeType_Move, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Strikback, false) ;---����
		SetModeEx(  _ownerID, EM_SetModeType_Searchenemy, false) ;---����
		SetModeEx( _ownerID , EM_SetModeType_Fight, false) ;---�i���ss
		SetModeEx( _ownerID , EM_SetModeType_Obstruct, false) ;---�i����
		--SetModeEx( _ownerID , EM_SetModeType_Show , false );

		BeginPlot( _ownerID , "Lua_70000899_Christmas_Item_GiftKeeper_OnDuty" , 20 );
	end

	function Lua_70000899_Christmas_Item_GiftKeeper_OnDuty()
		
		local _ownerID = OwnerID();

		while true do
			CastSpell( _ownerID , _ownerID , 31010316 , 1 );--31010207�ܴH�@��
			sleep( 5 );
		end
	end

	-------------------------------------------------------------END------Christmas_Items
	

	--return false;
--end--function Lua_70000899_ChristmasInit
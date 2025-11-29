<script lang="ts">
	import Button from '$lib/components/ui/Button.svelte';
	import {
		GITHUB_CLIENT_ID,
		GOOGLE_CLIENT_ID,
		type SocialProvider,
		ALLOWED_SOCIAL_PROVIDERS,
		VERCEL_CLIENT_ID,
		DISCORD_CLIENT_ID,
		MICROSOFT_CLIENT_ID,
		LINKEDIN_CLIENT_ID,
		FACEBOOK_CLIENT_ID,
		GITLAB_CLIENT_ID,
		HUGGINGFACE_CLIENT_ID,
		NOTION_CLIENT_ID,
		REDDIT_CLIENT_ID,
		SLACK_CLIENT_ID,
		SPOTIFY_CLIENT_ID,
		TWITTER_CLIENT_ID,
		TWITCH_CLIENT_ID,
		OAUTH_TEMPLATES,
		ENABLE_ANONYMOUS
	} from '$lib/utils/publicConstants';
	import { GithubIcon, Key } from '@lucide/svelte';
	import SocialIcons from '../ui/SocialIcons.svelte';

	interface Props {
		onSocialClickAction: (provider: SocialProvider) => void;
		onPasskeyClickAction: () => void;
		onAnonymousClickAction: () => void;
		isLoading?: boolean;
	}

	let { onSocialClickAction, onPasskeyClickAction, isLoading = false }: Props = $props();

	const params = new URLSearchParams(window.location.search);
	const templateParam = params.get('template') ?? 'popular';
	const inclusionParam = params.get('include')?.split(',') ?? [];
	const disclusionParam = params.get('exclude')?.split(',') ?? [];
	// Legacy support for 'disable' param
	const disableParam = params.get('disable')?.split(',') ?? [];
	const allDisclusions = [...disclusionParam, ...disableParam];

	const allProviderConfigs: {
		provider: SocialProvider;
		label: string;
		clientId: string | undefined | null;
	}[] = [
		{
			provider: 'passkey',
			label: 'Continue with Passkey',
			clientId: 'passkey'
		},
		{
			provider: 'anonymous',
			label: 'Continue as Guest',
			clientId: ENABLE_ANONYMOUS ? 'anonymous' : undefined
		},
		{
			provider: 'google',
			label: 'Continue with Google',
			clientId: GOOGLE_CLIENT_ID
		},
		{
			provider: 'github',
			label: 'Continue with GitHub',
			clientId: GITHUB_CLIENT_ID
		},
		{
			provider: 'discord',
			label: 'Continue with Discord',
			clientId: DISCORD_CLIENT_ID
		},
		{
			provider: 'microsoft',
			label: 'Continue with Microsoft',
			clientId: MICROSOFT_CLIENT_ID
		},
		{
			provider: 'linkedin',
			label: 'Continue with LinkedIn',
			clientId: LINKEDIN_CLIENT_ID
		},
		{
			provider: 'facebook',
			label: 'Continue with Facebook',
			clientId: FACEBOOK_CLIENT_ID
		},
		{
			provider: 'gitlab',
			label: 'Continue with GitLab',
			clientId: GITLAB_CLIENT_ID
		},
		{
			provider: 'huggingface',
			label: 'Continue with Huggingface',
			clientId: HUGGINGFACE_CLIENT_ID
		},
		{
			provider: 'notion',
			label: 'Continue with Notion',
			clientId: NOTION_CLIENT_ID
		},
		{
			provider: 'reddit',
			label: 'Continue with Reddit',
			clientId: REDDIT_CLIENT_ID
		},
		{
			provider: 'slack',
			label: 'Continue with Slack',
			clientId: SLACK_CLIENT_ID
		},
		{
			provider: 'spotify',
			label: 'Continue with Spotify',
			clientId: SPOTIFY_CLIENT_ID
		},
		{
			provider: 'twitter',
			label: 'Continue with Twitter',
			clientId: TWITTER_CLIENT_ID
		},
		{
			provider: 'twitch',
			label: 'Continue with Twitch',
			clientId: TWITCH_CLIENT_ID
		},
		{
			provider: 'vercel',
			label: 'Continue with Vercel',
			clientId: VERCEL_CLIENT_ID
		}
	];

	const getActiveProviders = () => {
		let baseProviders = OAUTH_TEMPLATES[templateParam] || OAUTH_TEMPLATES['popular'];
		if (baseProviders.length === 0) {
			baseProviders = OAUTH_TEMPLATES['popular'];
		}

		// Start with base template
		let active = new Set(baseProviders);

		// Add inclusions
		inclusionParam.forEach((p) => {
			if (ALLOWED_SOCIAL_PROVIDERS.includes(p as SocialProvider)) {
				active.add(p as SocialProvider);
			}
		});

		// Remove disclusions
		allDisclusions.forEach((p) => {
			active.delete(p as SocialProvider);
		});

		return Array.from(active)
			.map((p) => allProviderConfigs.find((c) => c.provider === p))
			.filter(
				(c): c is (typeof allProviderConfigs)[0] =>
					!!c && ALLOWED_SOCIAL_PROVIDERS.includes(c.provider)
			);
	};

	const activeProviders = getActiveProviders();
	const providerCount = activeProviders.length;

	// Adaptive layout classes
	let containerClass = 'space-y-3';
	let buttonClass = 'w-full flex items-center justify-center py-3';
	let iconClass = 'mr-2 h-5 w-5';
	let showLabel = true;

	if (providerCount > 3) {
		containerClass = 'grid grid-cols-4 gap-2';
		buttonClass = 'w-full flex items-center justify-center py-2 px-0';
		iconClass = 'h-5 w-5';
		showLabel = false;
	}
</script>

<div class={containerClass}>
	{#each activeProviders as config}
		<Button
			variant="outline"
			class={buttonClass}
			onclick={() => onSocialClickAction(config.provider)}
			disabled={isLoading}
		>
			<SocialIcons iconName={config.provider} class={iconClass} />
			{#if showLabel}
				{config.label}
			{/if}
		</Button>
	{/each}
</div>
